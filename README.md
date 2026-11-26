# 小书苑 Flutter MVP

## 当前包含
- Android / iOS 共用 Flutter 工程
- 暗黑金色视觉主题
- 首页、书架、发现、我的四个主入口
- 本地 TXT 导入
- EPUB 导入（读取 EPUB 压缩包中的 HTML/XHTML 正文）
- 阅读页、字号调整、深色/浅色阅读背景
- 本地设置持久化

## 运行
1. 安装 Flutter SDK，并配置 Android Studio（Android）或 Xcode（iOS）。
2. 在项目目录执行：
   ```bash
   flutter pub get
   flutter run
   ```
3. iOS 真机/模拟器构建需要 macOS 和 Xcode；Android 可在 Windows/macOS/Linux 构建。

## 重要说明
- 这是可运行的 MVP 工程源码，不是已经签名发布的 APK/IPA。
- 正版书库需要与出版社、版权方或合法内容服务商签约，并接入其 API；本工程暂未接入任何第三方书库。
- 当前书架与导入记录只保存在运行时内存中；下一阶段会增加本地数据库、阅读进度持久化、EPUB 目录/章节导航和云端同步。
- EPUB 当前按压缩包内 HTML 文件名排序提取正文，复杂 EPUB 的阅读顺序可能需要进一步适配 OPF spine。

## iOS 风格 UI 更新
- 大标题式页面头部与更宽松的留白
- 模糊半透明悬浮底部导航栏
- 柔和选中态和过渡动画
- 阅读页点击显示/隐藏控制栏
- 圆角毛玻璃阅读控制浮层与设置面板
- 设计方向参考 iOS 26 Liquid Glass 的层次、材质与交互原则；Flutter 自绘实现并非 Apple 官方组件

## 阅读主题更新
- 默认阅读主题调整为 Apple Books 风格的暖米白纸张
- 正文采用深棕色文字，减少纯白背景的视觉刺激
- 保留纯黑 AMOLED 深色阅读模式，可在个人中心切换

## 阅读主题工作室（V1.3）
- 9 套完整预设：奶油纸、羊皮古卷、雾蓝诗笺、樱花笺、薄荷森语、薰衣草、午夜墨黑、深海蓝、松针夜绿
- 实时阅读样张预览
- 可分别调整纸张背景色、正文文字色、强调色
- RGB 三通道调色，显示 HEX 色值
- 自定义配色保存在本机设置中，重启后保留
- 阅读页和个人中心均可打开主题工作室

## 整体界面风格选择（V1.4）
- 新增 6 套全局 APP 外观：暗夜鎏金、奶油书房、雾海蓝调、樱花物语、森林秘境、薰衣草夜
- 可切换首页背景、卡片、推荐横幅、导航栏、文字和强调色
- 外观预览卡可实时预览主要界面组成
- 支持收藏喜欢的整体风格，收藏状态与当前风格选择保存在本机
- 整体 APP 外观与阅读器纸张主题独立设置，可分别搭配


## 书源中心 V1.5
- 新增独立「书源」主导航入口
- 支持 JSON 文件批量导入、HTTPS 接口地址手动添加
- 支持正版授权书源与用户自有私人书源分类
- 支持启用/停用、单源连接测试、测速排序、删除
- 支持并发搜索多个已启用书源，并按响应耗时排序结果
- 按书名和作者去重
- 书源列表与状态写入 SharedPreferences
- 仅允许 HTTPS 公网接口；拒绝 localhost、常见私网/链路本地地址
- 不执行导入文件中的脚本或代码

### 书源 JSON 格式
单个书源：
```json
{
  "name": "我的私人书库",
  "endpoint": "https://books.example.org/api/search",
  "queryParam": "q",
  "kind": "私人书源",
  "enabled": true
}
```
批量文件可使用 JSON 数组，或 `{ "sources": [ ... ] }`。

### 搜索接口协议
请求示例：`GET https://books.example.org/api/search?q=三体`
响应可为数组，或 `{ "results": [ ... ] }`。每条结果至少提供 `title`，可选 `author`、`description`、`url`。`url` 仅接受 HTTPS 地址。
**注意：** 此 MVP 是通用接口适配约定，不会自动兼容任意网站 HTML、私有协议或未经授权的第三方 API。接入正版书库前需获得 API 文档、授权凭据和服务方许可。当前版本只展示搜索元数据，尚未实现第三方正文阅读/章节下载。


## V1.6：小说详情与阅读流程

本版本在 V1.5 基础上增加：
- 本地 TXT / EPUB 导入后可先进入小说详情页，查看简介占位信息和章节预览，再开始阅读。
- 阅读器增加章节目录入口，可跳转到对应章节段落。
- 在线搜索结果可点击进入详情页。
- 在线详情页支持读取书源提供的 HTTPS JSON 详情，并将获取到的正文加入书架。
- 在线详情 JSON 支持两种正文结构：
  - `{"content":"完整正文"}` 或 `{"text":"完整正文"}`
  - `{"chapters":[{"title":"第一章","content":"章节正文"}]}`
  - `chapters` 也可使用字符串数组。
- 在线接口仅适用于已获授权或用户有权访问的服务；搜索接口返回的 `url` 必须为 HTTPS。

### 当前边界
- 在线章节目前由详情 JSON 一次性返回，不支持按章节分页下载、登录态或平台专有鉴权流程。
- 本地 EPUB 当前沿用现有文本提取逻辑，目录按章节标题进行启发式拆分；复杂 EPUB 导航目录尚未完整解析。
- 阅读进度跨设备同步、精确段落续读与书签功能尚未实现。
- 尚未安装 Flutter/Dart SDK，当前源码未能执行 `flutter analyze`、编译或真机测试。请在安装 Flutter SDK 后运行 `flutter pub get` 与 `flutter analyze`，再进行设备测试。


## V1.7：开放式书源兼容导入器

- 书源导入支持 `.json` 与 `.txt`。
- 支持原生 JSON 数组、`sources` / `data` / `bookSources` 列表包装、单对象 JSON、JSON Lines。
- TXT 支持每行 `书源名称|HTTPS 搜索 API|搜索参数名` 的轻量格式（第三段可省略，默认 `q`）。
- 自动识别 `name` / `bookSourceName` / `title`、`endpoint` / `searchUrl` / `searchEndpoint` / `api`、`queryParam` / `searchParam` 等字段。
- 导入前提供预览，显示可导入数量和不兼容数量；重复地址自动跳过。
- 仅将明确声明的 HTTPS 搜索 API 转换为小书苑接口。常见阅读源中的网页 XPath/CSS 解析规则、任意 JavaScript、登录脚本、复杂鉴权和动态规则不会被执行，也不会伪装成可用 API。
- 导入后仍需在书源中心测试连接；搜索 API 响应需符合小书苑当前约定：JSON 数组或 `{ "results": [...] }`，结果包含 `title`。

### TXT 示例

`示例书源|https://api.example.com/search|keyword`

此处 `api.example.com` 仅为格式示例，不是实际书源。

### 安全与兼容说明

导入器不会运行来源文件中的代码，也不会访问非 HTTPS、localhost 或常见私有网络地址。阅读源仓库中的“站点地址 + 网页解析规则”并不等同于搜索 API；此类配置需要未来单独实现受限解析适配器，当前会标记为不兼容，而不是静默导入后让搜索失败。


## V1.7.1：GitHub 公版书库接入

GitHub 检索并参考了 `garethbjohnson/gutendex` 项目（https://github.com/garethbjohnson/gutendex），接入其 Project Gutenberg 元数据 API。

- 首次启动时自动加入 `Project Gutenberg 公版书库`，地址为 `https://gutendex.com/books/`，搜索参数为 `search`。
- 兼容 Gutendex 的 `results`、`authors`、`subjects`、`formats` 字段。
- 搜索结果优先选择纯文本格式链接；详情页可读取 HTTPS 纯文本正文，也保留原有 JSON 正文格式。
- 书源中心仍可删除该书源；删除后可通过“一键添加 Project Gutenberg 公版书库”重新添加。

Project Gutenberg 主要收录公版作品。不同国家/地区的版权期限可能不同，使用者仍需确认作品在所在地区的权利状态及 Project Gutenberg 的使用条款。此接入不包含未经授权的当代商业小说来源。


## V1.7.2：多题材公版书库

基于 GitHub 上的 Gutendex 项目（`garethbjohnson/gutendex`）与 Project Gutenberg 元数据 API，新增按题材筛选的预设书源：
- 综合书库
- 冒险
- 悬疑侦探
- 科幻
- 奇幻
- 历史

各题材源使用 Gutendex `topic` 参数筛选，并保留 `search` 参数用于关键词搜索。首次启动会自动补齐这些预设源；也可在书源中心通过“一键添加公版题材书库”恢复被删除的源。结果仍由 Gutendex 返回并去重，不会把 Open Library 等仅提供书目元数据的目录误当成可下载正文书源。

GitHub 上也检索到 Standard Ebooks 的 OPDS 相关实现（例如 `standardebooks/web` 和 `talebook/talebook` 中的适配器）。它采用 OPDS/Atom 目录格式，与当前小书苑 JSON 搜索协议不同，本次没有直接导入，避免添加后搜索实际不可用。后续可单独开发 OPDS 目录适配器。


## V2.0 书源分享与订阅增强
- 二维码分享当前书源配置，并复制 JSON 内容。
- 可将书源分享包导出为 JSON 文件，方便上传到可信 HTTPS 托管地址后分享订阅链接。
- 支持通过 HTTPS 配置链接订阅，并保存订阅地址。
- 支持手动更新已订阅配置；同一订阅中的书源会按名称/来源更新。
- 注意：应用本身不托管文件，因此不会凭空生成公网 HTTPS 分享链接；需要用户自行选择可信托管服务。


## V2.1 双平台构建准备

仓库已加入 `.github/workflows/build-mobile.yml`：
- GitHub Actions 自动生成 Android/iOS 平台工程。
- Android job 构建 Release APK，并上传为 `xiaoshuyuan-android-apk` artifact。
- iOS job 构建未签名的 Runner.app，并上传为 `xiaoshuyuan-ios-unsigned` artifact。

### 如何取得构建产物
1. 将工程推送到 GitHub 仓库的 `main` 或 `master` 分支。
2. 打开仓库的 Actions 页面，运行 `Build XiaoShuYuan mobile apps`。
3. 构建完成后，在该次 workflow run 的 Artifacts 区域下载 APK 或 iOS unsigned zip。

### iOS 安装说明
iOS unsigned zip 仅供开发和签名流程使用，不能直接安装到普通 iPhone。要生成可分发 IPA，需要在 macOS/Xcode 中配置 Apple Developer Team、Bundle ID、签名证书和 provisioning profile，然后进行 Archive / Export。不要把 Apple 证书或私钥提交到仓库。

### 本地构建
需安装 Flutter stable、Android SDK/JDK；iOS 还需 macOS、Xcode 和 CocoaPods。执行 `flutter pub get` 后，Android 使用 `flutter build apk --release`；iOS 使用 Xcode 配置签名后 `flutter build ipa --release`。
