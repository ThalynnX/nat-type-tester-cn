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

## 使用方法

1. 打开 App，默认使用内置公共 STUN（小米 / Google / Cloudflare）
2. 需要精确判断映射与过滤行为时，改为自建支持 RFC 5780 的 STUN 服务器（如 STUNTMAN）
3. 输入 `主机:端口`，选择 UDP 或 TCP，点击开始检测
4. 结果页给出映射行为、过滤行为、综合类型与完整日志

## 许可

MIT，详见 LICENSE。
