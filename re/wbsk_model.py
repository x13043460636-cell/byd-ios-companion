#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Wbsk 白盒 AES 参考模型（从 kongche 二进制逆向还原）+ 一致性验证。

数据来源：
- S-box/T-table/Xor 掩码表：迪控 APK assets/byd/wbsk_tables.json（与 kongche WbskTablesData 同源）
- 算法结构：kongche encryptBlock @0x10017296c 反汇编（见 re/encryptBlock.asm）
- nibble 辅助表：NIBBLE@0x1003daa38, MYSTERY@0x1003dab58（二进制直读）
"""
import json, base64, zipfile, struct, os, sys

APK = "C:/Users/Administrator/AppData/Local/Temp/dikong.apk"
BIN = "C:/Users/Administrator/AppData/Local/hermes/cache/scratch/kongche_main.bin"

def load_tables():
    z = zipfile.ZipFile(APK)
    j = json.loads(z.read("assets/byd/wbsk_tables.json"))
    t = {k: base64.b64decode(v) for k, v in j.items()}
    return t

def load_nibble_tables():
    main = open(BIN, "rb").read()
    BASE = 0x100000000
    off = lambda a: a - BASE
    nibble = main[off(0x1003daa38):off(0x1003daa38)+16]
    mystery = main[off(0x1003dab58):off(0x1003dab58)+16]
    return nibble, mystery

SHIFT = [0,5,10,15,4,9,14,3,8,13,2,7,12,1,6,11]

def nibmix(T, x, y):
    """还原自 encryptBlock：a=(x&F0)|(y>>4); b=((y&F)<<4)|(x&F); out=(T[a]&F0)|(T[b]>>4)"""
    a = (x & 0xF0) | (y >> 4)
    b = ((y & 0x0F) << 4) | (x & 0x0F)
    return ((T[a] & 0xF0) | (T[b] >> 4)) & 0xFF

def encrypt_block(inp, key, T):
    assert len(inp) == 16 and len(key) >= 16
    st = [nibmix(T["encInitXor"], inp[i], key[i]) for i in range(16)]
    num_rounds = len(key)//16 - 1
    for r in range(1, num_rounds):
        rk = key[16*r:16*r+16]
        # put 闭包 = 大端写字（非 XOR），后组覆盖前组 → 有效序列：
        B = bytearray(16); A = bytearray(16)
        for p in range(4):
            w = struct.unpack(">I", T["encTe0"][st[4*p]*4:st[4*p]*4+4])[0]
            B[4*p:4*p+4] = struct.pack(">I", w)
        for p in range(4):
            idx = st[(4*p+5) % 16]
            w = struct.unpack(">I", T["encTe1"][idx*4:idx*4+4])[0]
            A[4*p:4*p+4] = struct.pack(">I", w)
        for i in range(16):
            B[i] = nibmix(T["encRoundXor"], B[i], A[i])
        for p in range(4):
            idx = st[(4*p+10) % 16]
            w = struct.unpack(">I", T["encTe2"][idx*4:idx*4+4])[0]
            A[4*p:4*p+4] = struct.pack(">I", w)   # 二进制中此组为死代码，但保留以对齐时序
        for p in range(4):
            idx = st[(4*p+15) % 16]
            w = struct.unpack(">I", T["encTe3"][idx*4:idx*4+4])[0]
            A[4*p:4*p+4] = struct.pack(">I", w)
        for i in range(16):
            B[i] = nibmix(T["encRoundXor"], B[i], A[i])
        for i in range(16):
            st[i] = nibmix(T["encRoundXor"], B[i], rk[i])
    # 末轮
    t = [T["encSbox"][st[SHIFT[i]]] for i in range(16)]
    fk = key[16*num_rounds:16*num_rounds+16]
    return bytes(nibmix(T["encFinalXor"], t[i], fk[i]) for i in range(16))

def decrypt_block(inp, key, T):
    """encryptBlock 的结构镜像（dec 表），用于往返验证；待与 decryptBlock.asm 核对"""
    num_rounds = len(key)//16 - 1
    fk = key[16*num_rounds:16*num_rounds+16]
    # 逆末轮: out[i] = nibmix(FinalXor, t[i], fk[i]) → t[i] = nibmix(InvSbox?, out[i], fk[i])
    # 注意：decFinalXor/decInvSbox 的配合方式需与 decryptBlock.asm 核对，此处先按对称假设
    t = [nibmix(T["decFinalXor"], inp[i], fk[i]) for i in range(16)]
    st = [0]*16
    for i in range(16):
        st[SHIFT[i]] = T["decInvSbox"][t[i]]
    for r in range(num_rounds-1, 0, -1):
        rk = key[16*r:16*r+16]
        # 逆 nibmix 需要反向表；此处用穷举逆（16bit 空间可接受，仅为验证）
        B = bytes(_inv_nibmix(T["encRoundXor"], st[i], rk[i]) for i in range(16))
        # 逆第二轮 mix: B2 = nibmix(RX, B, A3) 其中 A3 = BE(Te3[...]) — 需 state，鸡生蛋
        # → 改为直接正向模拟 + 穷举不可行；真正的逆序实现需读 decryptBlock.asm（TODO M1 收尾）
        raise NotImplementedError("decryptBlock 需与 re/ 中反汇编核对后实现")

def _inv_nibmix(T, out, y):
    """穷举 nibmix 的逆（已知 T, out, y → x）"""
    for x in range(256):
        if nibmix(T, x, y) == out:
            return x
    raise ValueError("no inverse")

def self_checks(T):
    ok = True
    # 1. Sbox/InvSbox 互逆
    bad = [i for i in range(256) if T["encSbox"][T["decInvSbox"][i]] != i]
    print(f"[1] encSbox∘decInvSbox = identity: {'PASS' if not bad else 'FAIL ' + str(bad[:8])}")
    ok &= not bad
    # 2. Te1/2/3 = Te0 字节轮转
    bad = []
    for x in range(256):
        w = T["encTe0"][x*4:x*4+4]
        for k, name in ((1,"encTe1"),(2,"encTe2"),(3,"encTe3")):
            if T[name][x*4:x*4+4] != w[k:]+w[:k]:
                bad.append((x,name))
    print(f"[2] Te1/2/3 = Te0 字节轮转: {'PASS' if not bad else 'FAIL ' + str(bad[:4])}")
    ok &= not bad
    # 3. Td 同理
    bad = []
    for x in range(256):
        w = T["decTd0"][x*4:x*4+4]
        for k, name in ((1,"decTd1"),(2,"decTd2"),(3,"decTd3")):
            if T[name][x*4:x*4+4] != w[k:]+w[:k]:
                bad.append((x,name))
    print(f"[3] Td1/2/3 = Td0 字节轮转: {'PASS' if not bad else 'FAIL ' + str(bad[:4])}")
    ok &= not bad
    # 4. Te0 对 S(x) 的 GF(2) 仿射性（每个字节列独立）→ 提取白盒 MDS+掩码结构
    def col(w, j): return w[j]
    affine_ok = True
    # 以 S(x) 为输入做 GF(2) 线性检验：f(S(x)) = Te0col[x]
    # S 是双射 → 构造 g(v) = Te0col[S^{-1}(v)]，检验 g 是否仿射
    invS = [0]*256
    for i in range(256): invS[T["encSbox"][i]] = i
    for col in range(4):
        g = [T["encTe0"][x*4+col] for x in range(256)]
        g2 = [g[invS[v]] for v in range(256)]  # g2[v] = Te0col[S^{-1}(v)]
        # 仿射检验: g2[a^b] = g2[a]^g2[b]^g2[0]
        g0 = g2[0]
        for a in (1, 2, 4, 8, 16, 32, 64, 128):
            for b in range(1, 8):
                if g2[a^b] != g2[a]^g2[b]^g0:
                    affine_ok = False; break
            if not affine_ok: break
        if not affine_ok: break
    print(f"[4] Te0 列关于 S(x) GF(2) 仿射（白盒掩码结构检验）: {'PASS' if affine_ok else 'FAIL'}")
    ok &= affine_ok
    return ok

def parse_wbc_key(key_string: str):
    """还原自 parseWbcKey @0x1001721e0"""
    if len(key_string) < 5:
        raise ValueError("key too short")
    data = key_string.encode()
    seed = data[0] ^ data[3]
    key_data = bytes(data[4+i] ^ data[i % 3] for i in range(len(data)-4))
    cfg_table = [0x80,0x80,0xc0,0xc0,0x80,0x80,0x40,0x40]  # 二进制 @0x100262fd0（seed 0-7）
    if seed > 0x13:
        raise ValueError(f"invalid seed {seed}")
    if seed not in (6, 7, 14, 15):
        raise ValueError(f"seed {seed} not in {{6,7,14,15}}")
    cfg = cfg_table[seed] if seed < 8 else None  # seed 14/15 需读表后 8 项
    num_rounds = (cfg >> 5) + 6
    return key_data, num_rounds, seed

if __name__ == "__main__":
    T = load_tables()
    nib, mys = load_nibble_tables()
    print("NIBBLE :", nib.hex(" "))
    print("MYSTERY:", mys.hex(" "))
    print()
    ok = self_checks(T)
    print()
    # keyData 长度 = 16*(numRounds+1) → 对 8 轮需 144 字节 = 288 hex chars
    ks = "71ca0160b689febe1c11e07bc8f8cec81decf71b6c3e0be299a35211888c"
    try:
        kd, nr, seed = parse_wbc_key(ks)
        print(f"parse_wbc_key('{ks[:20]}...'): keyData={len(kd)}B numRounds={nr} seed={seed}")
        print(f"  seed check: '{ks[0]}'^'{ks[3]}' = {ord(ks[0])^ord(ks[3])}")
    except ValueError as e:
        print(f"parse_wbc_key: {e}")
    print("\n整体自洽:", "PASS" if ok else "FAIL")
