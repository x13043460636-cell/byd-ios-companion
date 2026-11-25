const w = require("E:/develop/code/byd-reference/BYD-re/wbsk.js");
const items = require("E:/develop/code/byd-ios-companion/re/official_envelopes.json");
for (const it of items) {
  const label = it[0], env = it[1];
  try {
    console.log("=== " + label + " ===");
    console.log(w.decryptEnvelope(env));
    console.log();
  } catch (e) {
    console.log("=== " + label + " === 解密失败: " + e.message);
  }
}
