# NAT 类型检测（中文版）

**作者**：ThalynnX · **邮箱**：leo@jiuyuewl.cn · **仓库**：https://github.com/ThalynnX/nat-type-tester-cn

原生 Android NAT 类型检测工具，基于 STUN 协议（RFC 3489 / 5389 / 5780），界面与检测结果全程中文。
本项目是 [vcgms/NAT-TypeTester](https://github.com/vcgms/NAT-Type-Tester)（MIT 许可）的中文本地化与重制版本。
MIT 许可要求保留原始版权声明，因此 LICENSE 中同时保留上游与本项目作者署名，其余品牌、包名、签名与文案均已替换为本项目所有。

## 功能特性

- 支持 **TCP** 与 **UDP** 双协议检测
- 识别 NAT 映射行为：端点无关映射、地址相关映射、地址与端口相关映射
- 识别 NAT 过滤行为：端点无关过滤、地址相关过滤、地址与端口相关过滤
- 综合判定 NAT 类型：全锥形、受限锥形、端口受限锥形、对称型、UDP 被阻断、其他类型
- 可折叠的检测详情与日志，一键复制检测日志
- 界面、结果、日志、复制文本全部中文化

## 界面与结果中文化

| 项目 | 处理 |
|---|---|
| 应用名称 | NAT 类型检测 |
| 首页副标题 | STUN 协议 · NAT 类型检测 |
| 映射/过滤行为 | 中文名称（不再显示 EIM/ADF 等英文缩写） |
| 空值显示 | 无（原为 N/A） |
| 检测日志 | 全部中文，含“同时变更 IP 与端口”“仅变更端口”等步骤说明 |
| 复制结果页脚 | NAT 类型检测工具 · ThalynnX |

## 构建

### Linux / macOS 通用

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64   # 需 JDK 17
export ANDROID_HOME=$HOME/android-sdk                   # 需 Android SDK 35 + build-tools 35
cd NatTypeTester-Android
./gradlew assembleRelease
```

构建产物：

```
NatTypeTester-Android/app/build/outputs/apk/release/NatTypeTester-1.1.31.apk
```

### 签名

仓库不包含密钥。在项目根目录放 `keystore.properties`（已在 .gitignore 中排除）：

```properties
storeFile=keystore/release.jks
storePassword=你的密码
keyAlias=jiuyuewl
keyPassword=你的密码
```

`app/build.gradle.kts` 检测到该文件即以 release 密钥签名，缺失时输出未签名包。

## 应用 ID

`cn.jiuyuewl.nattype`（与上游 `com.nattype.tester` 区分，可与上游版本共存安装）

## 1.1.33 修复说明（影响判定准确性的两个问题）

1. **CHANGE-REQUEST 属性类型用错**：旧版发的是 `0x8030`，而 RFC 3489/5780 标准是 `0x0003`。
   实测对 `stun.miwifi.com`：`0x0003` 的变更请求能拿到异地/异端口应答，`0x8030` 全部被忽略。
   结果是「变更请求等于没发出去」，过滤行为检测必然失败。
2. **失败后瞎猜 APDF**：旧版在两次变更请求都没被响应时，无条件返回「地址和端口相关过滤」，
   把全锥形网络（网页测出 NAT1）误判成端口受限锥形/对称型（NAT3/NAT4）。
   现在改为：服务器没认可变更请求时返回「过滤行为无法判定」；
   映射为端点无关时，综合结论显示「锥形 NAT（过滤未判定）」，不再谎报 NAT 类型。

## 内置公用 STUN 节点（11 个，均为实测可用）

| 节点 | 地址 | 实测 RTT | OTHER-ADDRESS |
|---|---|---|---|
| 小米 | stun.miwifi.com:3478 | 24ms | 有 |
| 哔哩哔哩 | stun.chat.bilibili.com:3478 | 14ms | 无 |
| 芒果TV | stun.hitv.com:3478 | 24ms | 无 |
| 斗鱼 | stun.douyucdn.cn:18000 | 21ms | 有（内网地址，不可直连） |
| 谷歌 | stun.l.google.com:19302 | 163ms | 无 |
| 谷歌3 | stun3.l.google.com:19302 | 177ms | 无 |
| 谷歌4 | stun4.l.google.com:19302 | 351ms | 无 |
| Cloudflare | stun.cloudflare.com:3478 | 145ms | 无 |
| Nextcloud 443 | stun.nextcloud.com:443 | 178ms | 有（同 IP 的 3478） |
| Nextcloud 3478 | stun.nextcloud.com:3478 | 190ms | 有（同 IP 的 443） |
| Linphone | stun.linphone.org:3478 | 196ms | 无 |

默认选中「小米」。国内线路优先：小米 / 哔哩哔哩 / 芒果TV / 斗鱼四个 RTT 在 25ms 内，适合移动网络。
国际节点（谷歌 / Cloudflare / Nextcloud / Linphone）在部分运营商链路下可能超时，可手动切换。
另有「自定义服务器」入口，可填任意 host:port。

## 使用方法

1. 打开 App，默认使用内置公共 STUN（小米 / Google / Cloudflare）
2. 需要精确判断映射与过滤行为时，改为自建支持 RFC 5780 的 STUN 服务器（如 STUNTMAN）
3. 输入 `主机:端口`，选择 UDP 或 TCP，点击开始检测
4. 结果页给出映射行为、过滤行为、综合类型与完整日志

## 许可

MIT，详见 LICENSE。
