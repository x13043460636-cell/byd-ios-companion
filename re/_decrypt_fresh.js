const w = require("E:/develop/code/byd-reference/BYD-re/wbsk.js");
const K = w.WBSK_KEYS;
const items = require("E:/develop/code/byd-ios-companion/re/fresh_envelopes.json");
const combos = [
  ["enc", K.outerEncryptKey, K.innerEncryptKey, K.outerEncryptIv],
  ["dec", K.outerDecryptKey, K.innerDecryptKey, K.outerDecryptIv],
];
for (const it of items) {
  const [label, env] = it;
  // 版本字节
  const raw = Buffer.from(env, "base64");
  console.log(`=== ${label} === 前3字节: ${raw.slice(0,3).toString("hex")} 总长: ${raw.length}`);
  for (const [tag, ok, ik, iv] of combos) {
    try {
      const s = w.decryptEnvelope(env, ok, ik, iv);
      const printable = s.replace(/[^\x20-\x7e]/g, ".").substring(0, 200);
      const looksJson = /[{[]/.test(s.substring(0, 3));
      console.log(`  [${tag}] ${looksJson ? "✓ JSON!" : "乱码"}: ${printable}`);
      if (looksJson) { console.log("  明文:", s.substring(0, 2000)); break; }
    } catch (e) {
      console.log(`  [${tag}] 异常: ${e.message}`);
    }
  }
}
