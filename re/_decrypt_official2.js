const w = require("E:/develop/code/byd-reference/BYD-re/wbsk.js");
const K = w.WBSK_KEYS;
const items = require("E:/develop/code/byd-ios-companion/re/official_envelopes.json");
// 请求信封: 用 encrypt 侧密钥解; 响应信封: 用 decrypt 侧密钥解
const combos = [
  ["enc侧", K.outerEncryptKey, K.innerEncryptKey, K.outerEncryptIv],
  ["dec侧", K.outerDecryptKey, K.innerDecryptKey, K.outerDecryptIv],
];
for (const it of items) {
  const label = it[0], env = it[1];
  let ok = false;
  for (const [tag, ok_hex, ik, iv] of combos) {
    try {
      const s = w.decryptEnvelope(env, ok_hex, ik, iv);
      if (/^\s*[{\[]/.test(s) || s.includes("appChannel") || s.includes("uuid") || s.includes(":")) {
        console.log("=== " + label + " [" + tag + "] ===");
        console.log(s.substring(0, 1500));
        console.log();
        ok = true; break;
      }
    } catch (e) { /* 试下一组 */ }
  }
  if (!ok) console.log("=== " + label + " === 两侧密钥都无法解出明文");
}
