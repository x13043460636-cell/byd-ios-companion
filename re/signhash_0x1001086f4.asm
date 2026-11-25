0x1001086f4  sub      sp, sp, #0x120
0x1001086f8  stp      x28, x27, [sp, #0xc0]
0x1001086fc  stp      x26, x25, [sp, #0xd0]
0x100108700  stp      x24, x23, [sp, #0xe0]
0x100108704  stp      x22, x21, [sp, #0xf0]
0x100108708  stp      x20, x19, [sp, #0x100]
0x10010870c  stp      x29, x30, [sp, #0x110]
0x100108710  add      x29, sp, #0x110
0x100108714  mov      x19, x1
0x100108718  mov      x20, x0
0x10010871c  mov      x21, #0
0x100108720  adrp     x8, #0x1003bc000
0x100108724  ldr      x8, [x8, #0xb40]
0x100108728  ldr      x8, [x8]
0x10010872c  stur     x8, [x29, #-0x60]
0x100108730  stp      x0, x1, [sp, #0x40]
0x100108734  stp      x0, x1, [sp, #0x30]
0x100108738  mov      x0, x1
0x10010873c  bl       #0x10025a2e8
0x100108740  adrp     x0, #0x1003d7000
0x100108744  add      x0, x0, #0xb78
0x100108748  adrp     x1, #0x100261000
0x10010874c  add      x1, x1, #0xe08
0x100108750  bl       #0x100005294
0x100108754  mov      x3, x0
0x100108758  adrp     x2, #0x1003be000
0x10010875c  ldr      x2, [x2, #0x2f0]
0x100108760  add      x0, sp, #0x50
0x100108764  add      x1, sp, #0x30
0x100108768  mov      w4, #6
0x10010876c  bl       #0x10025a33c
0x100108770  cbz      w0, #0x1001087c8
0x100108774  add      x0, sp, #0x50
0x100108778  add      x1, sp, #0x80
0x10010877c  bl       #0x100113808
0x100108780  ldp      x22, x23, [sp, #0x98]
0x100108784  add      x0, sp, #0x80
0x100108788  mov      x1, x22
0x10010878c  bl       #0x1000228d8
0x100108790  mov      x20, x0
0x100108794  adrp     x0, #0x100111000
0x100108798  add      x0, x0, #0x1d4
0x10010879c  adrp     x2, #0x1003bc000
0x1001087a0  ldr      x2, [x2, #0x610]
0x1001087a4  add      x8, sp, #0x50
0x1001087a8  mov      x1, #0
0x1001087ac  mov      x21, #0
0x1001087b0  mov      x3, x22
0x1001087b4  mov      x4, x23
0x1001087b8  bl       #0x100257fa8
0x1001087bc  add      x0, sp, #0x80
0x1001087c0  bl       #0x100007610
0x1001087c4  b        #0x100108b30
0x1001087c8  str      xzr, [sp, #0x70]
0x1001087cc  movi     v0.16b, #0
0x1001087d0  stp      q0, q0, [sp, #0x50]
0x1001087d4  adrp     x1, #0x1003d7000
0x1001087d8  add      x1, x1, #0xb80
0x1001087dc  adrp     x2, #0x100261000
0x1001087e0  add      x2, x2, #0xe10
0x1001087e4  add      x0, sp, #0x50
0x1001087e8  bl       #0x1000075d0
0x1001087ec  tbnz     x19, #0x3c, #0x100108b9c
0x1001087f0  tbnz     x19, #0x3d, #0x100108820
0x1001087f4  tbz      x20, #0x3c, #0x100108bb4
0x1001087f8  and      x8, x19, #0xfffffffffffffff
0x1001087fc  add      x0, x8, #0x20
0x100108800  and      x1, x20, #0xffffffffffff
0x100108804  add      x8, x1, x0
0x100108808  cmp      x0, #0
0x10010880c  csel     x1, xzr, x8, eq
0x100108810  bl       #0x1001134ac
0x100108814  mov      x22, x0
0x100108818  mov      x23, x1
0x10010881c  b        #0x100108844
0x100108820  ubfx     x1, x19, #0x38, #4
0x100108824  and      x8, x19, #0xffffffffffffff
0x100108828  stp      x20, x8, [sp, #0x50]
0x10010882c  add      x8, sp, #0x80
0x100108830  add      x0, sp, #0x50
0x100108834  mov      x21, #0
0x100108838  bl       #0x100110d70
0x10010883c  cbnz     x21, #0x100108bd4
0x100108840  ldp      x22, x23, [sp, #0x80]
0x100108844  lsr      x8, x23, #0x3c
0x100108848  cmp      x8, #0xe
0x10010884c  b.ls     #0x1001088b4
0x100108850  and      x8, x20, #0xffffffffffff
0x100108854  ubfx     x9, x19, #0x38, #4
0x100108858  tst      x19, #0x2000000000000000
0x10010885c  csel     x0, x8, x9, eq
0x100108860  bl       #0x100113510
0x100108864  stp      x0, x1, [sp, #0x50]
0x100108868  add      x8, sp, #0x40
0x10010886c  str      x8, [sp, #0x90]
0x100108870  adrp     x0, #0x100113000
0x100108874  add      x0, x0, #0x7f0
0x100108878  add      x1, sp, #0x80
0x10010887c  add      x20, sp, #0x50
0x100108880  bl       #0x100110e3c
0x100108884  mov      x24, x0
0x100108888  mov      x21, x1
0x10010888c  mov      x25, x2
0x100108890  ldp      x8, x9, [sp, #0x50]
0x100108894  lsr      x10, x9, #0x3e
0x100108898  cmp      w10, #1
0x10010889c  b.gt     #0x1001088bc
0x1001088a0  cbnz     w10, #0x1001088dc
0x1001088a4  ubfx     x11, x9, #0x30, #8
0x1001088a8  cmp      x3, x11
0x1001088ac  b.ne     #0x1001088f4
0x1001088b0  b        #0x100108918
0x1001088b4  stp      x22, x23, [sp, #0x50]
0x1001088b8  b        #0x100108b30
0x1001088bc  cmp      w10, #2
0x1001088c0  b.ne     #0x10010890c
0x1001088c4  ldp      x12, x11, [x8, #0x10]
0x1001088c8  subs     x11, x11, x12
0x1001088cc  b.vs     #0x100108bc8
0x1001088d0  cmp      x3, x11
0x1001088d4  b.ne     #0x1001088f4
0x1001088d8  b        #0x100108918
0x1001088dc  lsr      x11, x8, #0x20
0x1001088e0  subs     w11, w11, w8
0x1001088e4  b.vs     #0x100108bcc
0x1001088e8  sxtw     x11, w11
0x1001088ec  cmp      x3, x11
0x1001088f0  b.eq     #0x100108918
0x1001088f4  cmp      w10, #2
0x1001088f8  b.eq     #0x100108b00
0x1001088fc  cmp      w10, #1
0x100108900  b.ne     #0x100108b08
0x100108904  asr      x1, x8, #0x20
0x100108908  b        #0x100108b0c
0x10010890c  cbz      x3, #0x100108918
0x100108910  mov      x1, #0
0x100108914  b        #0x100108b0c
0x100108918  str      x23, [sp, #0x10]
0x10010891c  and      x8, x24, #0xffffffffffff
0x100108920  ubfx     x9, x21, #0x38, #4
0x100108924  tst      x21, #0x2000000000000000
0x100108928  csel     x26, x8, x9, eq
0x10010892c  lsl      x27, x26, #2
0x100108930  stur     xzr, [sp, #0x36]
0x100108934  str      xzr, [sp, #0x30]
0x100108938  cmp      x27, x25, lsr #14
0x10010893c  b.eq     #0x100108ae8
0x100108940  str      x22, [sp, #8]
0x100108944  mov      w28, #0
0x100108948  tst      x21, #0x1000000000000000
0x10010894c  ubfx     x8, x24, #0x3b, #1
0x100108950  csinc    w8, w8, wzr, ne
0x100108954  mov      w9, #4
0x100108958  lsl      x22, x9, x8
0x10010895c  and      x9, x21, #0xffffffffffffff
0x100108960  and      x8, x21, #0xfffffffffffffff
0x100108964  add      x8, x8, #0x20
0x100108968  stp      x8, x9, [sp, #0x18]
0x10010896c  b        #0x100108978
0x100108970  cmp      x27, x25, lsr #14
0x100108974  b.eq     #0x100108aa8
0x100108978  and      x23, x25, #0xc
0x10010897c  mov      x0, x25
0x100108980  cmp      x23, x22
0x100108984  b.eq     #0x1001089e4
0x100108988  lsr      x20, x0, #0x10
0x10010898c  cmp      x20, x26
0x100108990  b.hs     #0x100108b90
0x100108994  tbnz     x21, #0x3c, #0x1001089f8
0x100108998  tbnz     x21, #0x3d, #0x1001089b4
0x10010899c  ldr      x0, [sp, #0x18]
0x1001089a0  tbz      x24, #0x3c, #0x100108a98
0x1001089a4  ldrb     w20, [x0, x20]
0x1001089a8  cmp      x23, x22
0x1001089ac  b.ne     #0x1001089cc
0x1001089b0  b        #0x100108a10
0x1001089b4  ldr      x8, [sp, #0x20]
0x1001089b8  stp      x24, x8, [sp, #0x80]
0x1001089bc  add      x8, sp, #0x80
0x1001089c0  ldrb     w20, [x8, x20]
0x1001089c4  cmp      x23, x22
0x1001089c8  b.eq     #0x100108a10
0x1001089cc  tbnz     x21, #0x3c, #0x100108a28
0x1001089d0  and      x8, x25, #0xffffffffffff0000
0x1001089d4  mov      w9, #4
0x1001089d8  movk     w9, #1, lsl #16
0x1001089dc  add      x25, x8, x9
0x1001089e0  b        #0x100108a44
0x1001089e4  mov      x0, x25
0x1001089e8  mov      x1, x24
0x1001089ec  mov      x2, x21
0x1001089f0  bl       #0x10008ec44
0x1001089f4  b        #0x100108988
0x1001089f8  mov      x1, x24
0x1001089fc  mov      x2, x21
0x100108a00  bl       #0x10025979c
0x100108a04  mov      x20, x0
0x100108a08  cmp      x23, x22
0x100108a0c  b.ne     #0x1001089cc
0x100108a10  mov      x0, x25
0x100108a14  mov      x1, x24
0x100108a18  mov      x2, x21
0x100108a1c  bl       #0x10008ec44
0x100108a20  mov      x25, x0
0x100108a24  tbz      x21, #0x3c, #0x1001089d0
0x100108a28  cmp      x26, x25, lsr #16
0x100108a2c  b.ls     #0x100108b98
0x100108a30  mov      x0, x25
0x100108a34  mov      x1, x24
0x100108a38  mov      x2, x21
0x100108a3c  bl       #0x100259778
0x100108a40  mov      x25, x0
0x100108a44  and      x8, x28, #0xff
0x100108a48  and      w9, w28, #0xff
0x100108a4c  add      x10, sp, #0x30
0x100108a50  strb     w20, [x10, x8]
0x100108a54  add      w28, w9, #1
0x100108a58  lsr      w8, w28, #8
0x100108a5c  tbnz     w8, #0, #0x100108b94
0x100108a60  and      w8, w28, #0xff
0x100108a64  cmp      w8, #0xe
0x100108a68  b.ne     #0x100108970
0x100108a6c  ldr      x8, [sp, #0x30]
0x100108a70  str      x8, [sp, #0x80]
0x100108a74  ldur     x8, [sp, #0x36]
0x100108a78  stur     x8, [sp, #0x86]
0x100108a7c  add      x0, sp, #0x80
0x100108a80  add      x8, sp, #0x80
0x100108a84  add      x1, x8, #0xe
0x100108a88  add      x20, sp, #0x50
0x100108a8c  bl       #0x10025817c
0x100108a90  mov      w28, #0
0x100108a94  b        #0x100108970
0x100108a98  mov      x0, x24
0x100108a9c  mov      x1, x21
0x100108aa0  bl       #0x100259bb0
0x100108aa4  b        #0x1001089a4
0x100108aa8  tst      w28, #0xff
0x100108aac  ldr      x22, [sp, #8]
0x100108ab0  b.eq     #0x100108ae8
0x100108ab4  ldr      x8, [sp, #0x30]
0x100108ab8  str      x8, [sp, #0x80]
0x100108abc  ldur     x8, [sp, #0x36]
0x100108ac0  stur     x8, [sp, #0x86]
0x100108ac4  add      x8, sp, #0x80
0x100108ac8  add      x1, x8, w28, uxtb
0x100108acc  add      x0, sp, #0x80
0x100108ad0  add      x20, sp, #0x50
0x100108ad4  bl       #0x10025817c
0x100108ad8  mov      x0, x22
0x100108adc  ldr      x1, [sp, #0x10]
0x100108ae0  bl       #0x10002a9fc
0x100108ae4  b        #0x100108b28
0x100108ae8  mov      x0, x21
0x100108aec  bl       #0x10025a2d0
0x100108af0  mov      x0, x22
0x100108af4  ldr      x1, [sp, #0x10]
0x100108af8  bl       #0x10002a9fc
0x100108afc  b        #0x100108b30
0x100108b00  ldr      x1, [x8, #0x18]
0x100108b04  b        #0x100108b0c
0x100108b08  ubfx     x1, x9, #0x30, #8
0x100108b0c  cmp      x1, x3
0x100108b10  b.lt     #0x100108bc4
0x100108b14  add      x20, sp, #0x50
0x100108b18  mov      x0, x3
0x100108b1c  mov      x2, #0
0x100108b20  mov      x3, #0
0x100108b24  bl       #0x100258170
0x100108b28  mov      x0, x21
0x100108b2c  bl       #0x10025a2d0
0x100108b30  ldp      x20, x21, [sp, #0x50]
0x100108b34  mov      x0, x20
0x100108b38  mov      x1, x21
0x100108b3c  bl       #0x100091450
0x100108b40  mov      x0, x19
0x100108b44  bl       #0x10025a2d0
0x100108b48  ldp      x0, x1, [sp, #0x50]
0x100108b4c  bl       #0x100022818
0x100108b50  ldur     x8, [x29, #-0x60]
0x100108b54  adrp     x9, #0x1003bc000
0x100108b58  ldr      x9, [x9, #0xb40]
0x100108b5c  ldr      x9, [x9]
0x100108b60  cmp      x9, x8
0x100108b64  b.ne     #0x100108bd0
0x100108b68  mov      x0, x20
0x100108b6c  mov      x1, x21
0x100108b70  ldp      x29, x30, [sp, #0x110]
0x100108b74  ldp      x20, x19, [sp, #0x100]
0x100108b78  ldp      x22, x21, [sp, #0xf0]
0x100108b7c  ldp      x24, x23, [sp, #0xe0]
0x100108b80  ldp      x26, x25, [sp, #0xd0]
0x100108b84  ldp      x28, x27, [sp, #0xc0]
0x100108b88  add      sp, sp, #0x120
0x100108b8c  ret      
0x100108b90  brk      #1
0x100108b94  brk      #1
0x100108b98  brk      #1
0x100108b9c  mov      x0, x20
0x100108ba0  mov      x1, x19
0x100108ba4  bl       #0x10025976c
0x100108ba8  mov      x22, #0
0x100108bac  mov      x23, #-0x1000000000000000
0x100108bb0  b        #0x100108860
0x100108bb4  mov      x0, x20
0x100108bb8  mov      x1, x19
0x100108bbc  bl       #0x100259bb0
0x100108bc0  b        #0x100108804
0x100108bc4  brk      #1
0x100108bc8  brk      #1
0x100108bcc  brk      #1
0x100108bd0  bl       #0x100259f64
0x100108bd4  mov      x0, x21
0x100108bd8  bl       #0x10025a36c
0x100108bdc  brk      #1
0x100108be0  sub      sp, sp, #0x90
0x100108be4  stp      x26, x25, [sp, #0x40]
0x100108be8  stp      x24, x23, [sp, #0x50]
0x100108bec  stp      x22, x21, [sp, #0x60]
0x100108bf0  stp      x20, x19, [sp, #0x70]
0x100108bf4  stp      x29, x30, [sp, #0x80]
0x100108bf8  add      x29, sp, #0x80
0x100108bfc  mov      x19, x3
0x100108c00  mov      x20, x2
0x100108c04  mov      x21, x1
0x100108c08  mov      x22, x0
0x100108c0c  adrp     x23, #0x1003d7000
0x100108c10  add      x23, x23, #0xbf0
0x100108c14  adrp     x24, #0x100261000
0x100108c18  add      x24, x24, #0xe50
0x100108c1c  mov      x0, x23
0x100108c20  mov      x1, x24
0x100108c24  bl       #0x100005294
0x100108c28  mov      x25, x0
0x100108c2c  str      x0, [sp, #0x20]
0x100108c30  adrp     x0, #0x1003d7000
0x100108c34  add      x0, x0, #0xbf8
0x100108c38  adrp     x3, #0x1003bc000
0x100108c3c  ldr      x3, [x3, #0x9b0]
0x100108c40  mov      x1, x23
0x100108c44  mov      x2, x24
0x100108c48  bl       #0x10000766c
0x100108c4c  str      x0, [sp, #0x28]
0x100108c50  adrp     x0, #0x1003c3000
0x100108c54  add      x0, x0, #0x450
0x100108c58  mov      w1, #0x30
0x100108c5c  mov      w2, #7
0x100108c60  bl       #0x10025a288
0x100108c64  str      x0, [sp, #8]
0x100108c68  stp      x22, x21, [x0, #0x10]
0x100108c6c  stp      x20, x19, [x0, #0x20]
0x100108c70  add      x0, sp, #8
0x100108c74  mov      x1, x25
0x100108c78  bl       #0x1000228d8
0x100108c7c  ldp      x8, x9, [x0, #0x10]
0x100108c80  lsr      x9, x9, #1
0x100108c84  subs     x9, x9, x8
0x100108c88  b.vs     #0x100108ccc
0x100108c8c  ldr      x10, [x0, #8]
0x100108c90  add      x0, x10, x8
0x100108c94  add      x8, sp, #0x30
0x100108c98  add      x1, x0, x9
0x100108c9c  mov      x21, #0
0x100108ca0  bl       #0x1001111d4
0x100108ca4  add      x0, sp, #8
0x100108ca8  bl       #0x100007610
0x100108cac  ldp      x0, x1, [sp, #0x30]
0x100108cb0  ldp      x29, x30, [sp, #0x80]
0x100108cb4  ldp      x20, x19, [sp, #0x70]
0x100108cb8  ldp      x22, x21, [sp, #0x60]
0x100108cbc  ldp      x24, x23, [sp, #0x50]
0x100108cc0  ldp      x26, x25, [sp, #0x40]
0x100108cc4  add      sp, sp, #0x90
0x100108cc8  ret      
0x100108ccc  brk      #1
0x100108cd0  sub      sp, sp, #0x90
0x100108cd4  stp      x28, x27, [sp, #0x30]
0x100108cd8  stp      x26, x25, [sp, #0x40]
0x100108cdc  stp      x24, x23, [sp, #0x50]
0x100108ce0  stp      x22, x21, [sp, #0x60]
0x100108ce4  stp      x20, x19, [sp, #0x70]
0x100108ce8  stp      x29, x30, [sp, #0x80]
0x100108cec  add      x29, sp, #0x80
0x100108cf0  mov      x19, x20
0x100108cf4  mov      x22, x1
0x100108cf8  mov      x24, x0
0x100108cfc  bl       #0x100108f78
0x100108d00  mov      x23, x0
0x100108d04  and      x8, x0, #0xffffffffffffff8
0x100108d08  lsr      x26, x0, #0x3e
0x100108d0c  cbnz     x26, #0x100108eb8
0x100108d10  ldr      x20, [x8, #0x10]
0x100108d14  cbz      x20, #0x100108ecc
0x100108d18  stp      x24, x22, [sp, #8]
0x100108d1c  mov      x24, #0
0x100108d20  adrp     x8, #0x1003d7000
0x100108d24  ldr      x8, [x8, #0xa50]
0x100108d28  ldr      x25, [x19, x8]
0x100108d2c  and      x21, x23, #0xc000000000000001
0x100108d30  and      x27, x23, #0xffffffffffffff8
0x100108d34  cbnz     x21, #0x100108d7c
0x100108d38  ldr      x8, [x27, #0x10]
0x100108d3c  cmp      x24, x8
0x100108d40  b.hs     #0x100108eb4
0x100108d44  add      x8, x23, x24, lsl #3
0x100108d48  ldr      x8, [x8, #0x20]
0x100108d4c  bl       #0x10025a210
0x100108d50  mov      x28, x0
0x100108d54  adds     x22, x24, #1
0x100108d58  b.vs     #0x100108eb0
0x100108d5c  mov      x0, x25
0x100108d60  mov      x2, x28
0x100108d64  bl       #0x10025b4c0
0x100108d68  bl       #0x10025a12c
0x100108d6c  add      x24, x24, #1
0x100108d70  cmp      x22, x20
0x100108d74  b.ne     #0x100108d34
0x100108d78  b        #0x100108d9c
0x100108d7c  mov      x0, x24
0x100108d80  mov      x1, x23
0x100108d84  adrp     x2, #0x1003d1000
0x100108d88  add      x2, x2, #0x390
0x100108d8c  adrp     x3, #0x1003d4000
0x100108d90  add      x3, x3, #0x5e8
0x100108d94  bl       #0x100110b28
0x100108d98  b        #0x100108d50
0x100108d9c  mov      x24, #0x1d
0x100108da0  movk     x24, #0x1000, lsl #48
0x100108da4  mov      x8, #-0x2000000000000000
0x100108da8  stp      xzr, x8, [sp, #0x20]
0x100108dac  add      x20, sp, #0x20
0x100108db0  mov      w0, #0x5c
0x100108db4  bl       #0x100259b8c
0x100108db8  ldp      x8, x9, [sp, #0x20]
0x100108dbc  stp      x8, x9, [sp, #0x20]
0x100108dc0  adrp     x8, #0x1002cd000
0x100108dc4  add      x8, x8, #0x9c0
0x100108dc8  sub      x8, x8, #0x20
0x100108dcc  orr      x1, x8, #0x8000000000000000
0x100108dd0  add      x20, sp, #0x20
0x100108dd4  mov      x0, #0x1d
0x100108dd8  movk     x0, #0x1000, lsl #48
0x100108ddc  bl       #0x100259754
0x100108de0  add      x20, sp, #0x20
0x100108de4  ldp      x0, x1, [sp, #8]
0x100108de8  bl       #0x100259754
0x100108dec  adrp     x8, #0x1002cd000
0x100108df0  add      x8, x8, #0x9e0
0x100108df4  sub      x8, x8, #0x20
0x100108df8  sub      x0, x24, #0xd
0x100108dfc  orr      x1, x8, #0x8000000000000000
0x100108e00  add      x20, sp, #0x20
0x100108e04  bl       #0x100259754
0x100108e08  cbnz     x26, #0x100108e14
0x100108e0c  ldr      x20, [x27, #0x10]
0x100108e10  b        #0x100108e24
0x100108e14  tst      x23, #-0x8000000000000000
0x100108e18  csel     x0, x27, x23, eq
0x100108e1c  bl       #0x100259c04
0x100108e20  mov      x20, x0
0x100108e24  mov      x0, x23
0x100108e28  bl       #0x10025a2d0
0x100108e2c  str      x20, [sp, #0x18]
0x100108e30  adrp     x0, #0x1003be000
0x100108e34  ldr      x0, [x0, #0x438]
0x100108e38  adrp     x1, #0x1003be000
0x100108e3c  ldr      x1, [x1, #0x468]
0x100108e40  add      x20, sp, #0x18
0x100108e44  bl       #0x100259d24
0x100108e48  mov      x21, x1
0x100108e4c  add      x20, sp, #0x20
0x100108e50  bl       #0x100259754
0x100108e54  mov      x0, x21
0x100108e58  bl       #0x10025a2d0
0x100108e5c  adrp     x8, #0x1002cd000
0x100108e60  add      x8, x8, #0xa00
0x100108e64  sub      x8, x8, #0x20
0x100108e68  add      x0, x24, #0xe
0x100108e6c  orr      x1, x8, #0x8000000000000000
0x100108e70  add      x20, sp, #0x20
0x100108e74  bl       #0x100259754
0x100108e78  ldp      x0, x21, [sp, #0x20]
0x100108e7c  mov      x1, x21
0x100108e80  mov      x20, x19
0x100108e84  bl       #0x10010c374
0x100108e88  mov      x0, x21
0x100108e8c  bl       #0x10025a2d0
0x100108e90  ldp      x29, x30, [sp, #0x80]
0x100108e94  ldp      x20, x19, [sp, #0x70]
0x100108e98  ldp      x22, x21, [sp, #0x60]
0x100108e9c  ldp      x24, x23, [sp, #0x50]
0x100108ea0  ldp      x26, x25, [sp, #0x40]
0x100108ea4  ldp      x28, x27, [sp, #0x30]
0x100108ea8  add      sp, sp, #0x90
0x100108eac  ret      
0x100108eb0  brk      #1
0x100108eb4  brk      #1
0x100108eb8  tst      x23, #-0x8000000000000000
0x100108ebc  csel     x0, x8, x23, eq
0x100108ec0  bl       #0x100259c04
0x100108ec4  mov      x20, x0
0x100108ec8  cbnz     x20, #0x100108d18
0x100108ecc  mov      x0, x23
0x100108ed0  bl       #0x10025a2d0
0x100108ed4  mov      x8, #-0x2000000000000000
0x100108ed8  stp      xzr, x8, [sp, #0x20]
0x100108edc  add      x20, sp, #0x20
0x100108ee0  mov      w0, #0x60
0x100108ee4  bl       #0x100259b8c
0x100108ee8  ldp      x8, x9, [sp, #0x20]
0x100108eec  stp      x8, x9, [sp, #0x20]
0x100108ef0  adrp     x8, #0x1002cd000
0x100108ef4  add      x8, x8, #0x9c0
0x100108ef8  sub      x8, x8, #0x20
0x100108efc  mov      x21, #0x1d
0x100108f00  movk     x21, #0x1000, lsl #48
0x100108f04  orr      x1, x8, #0x8000000000000000
0x100108f08  add      x20, sp, #0x20
0x100108f0c  mov      x0, #0x1d
0x100108f10  movk     x0, #0x1000, lsl #48
0x100108f14  bl       #0x100259754
0x100108f18  add      x20, sp, #0x20
0x100108f1c  mov      x0, x24
0x100108f20  mov      x1, x22
0x100108f24  bl       #0x100259754
0x100108f28  adrp     x8, #0x1002cd000
0x100108f2c  add      x8, x8, #0xa30
0x100108f30  sub      x8, x8, #0x20
0x100108f34  add      x0, x21, #0x24
0x100108f38  orr      x1, x8, #0x8000000000000000
0x100108f3c  add      x20, sp, #0x20
0x100108f40  bl       #0x100259754
0x100108f44  ldp      x0, x21, [sp, #0x20]
0x100108f48  mov      x1, x21
0x100108f4c  mov      x20, x19
0x100108f50  bl       #0x10010c374
0x100108f54  mov      x0, x21
0x100108f58  ldp      x29, x30, [sp, #0x80]
0x100108f5c  ldp      x20, x19, [sp, #0x70]
0x100108f60  ldp      x22, x21, [sp, #0x60]
0x100108f64  ldp      x24, x23, [sp, #0x50]
0x100108f68  ldp      x26, x25, [sp, #0x40]
0x100108f6c  ldp      x28, x27, [sp, #0x30]
0x100108f70  add      sp, sp, #0x90
0x100108f74  b        #0x10025a2d0
0x100108f78  sub      sp, sp, #0x80
0x100108f7c  stp      x28, x27, [sp, #0x20]
0x100108f80  stp      x26, x25, [sp, #0x30]
0x100108f84  stp      x24, x23, [sp, #0x40]
0x100108f88  stp      x22, x21, [sp, #0x50]
0x100108f8c  stp      x20, x19, [sp, #0x60]
0x100108f90  stp      x29, x30, [sp, #0x70]
0x100108f94  add      x29, sp, #0x70
0x100108f98  adrp     x8, #0x1003d7000
0x100108f9c  ldr      x8, [x8, #0xa50]
0x100108fa0  ldr      x0, [x20, x8]
0x100108fa4  bl       #0x10025b240
0x100108fa8  mov      x29, x29
0x100108fac  bl       #0x10025a15c
0x100108fb0  mov      x19, x0
0x100108fb4  adrp     x1, #0x1003d7000
0x100108fb8  add      x1, x1, #0xba0
0x100108fbc  adrp     x2, #0x1003d1000
0x100108fc0  add      x2, x2, #0x440
0x100108fc4  mov      x0, #0
0x100108fc8  bl       #0x10007ee58
0x100108fcc  mov      x20, x0
0x100108fd0  bl       #0x100113820
0x100108fd4  mov      x2, x0
0x100108fd8  mov      x0, x19
0x100108fdc  mov      x1, x20
0x100108fe0  bl       #0x100259928
0x100108fe4  mov      x20, x0
0x100108fe8  bl       #0x10025a0c0
0x100108fec  mov      x0, x20
0x100108ff0  mov      x21, #0