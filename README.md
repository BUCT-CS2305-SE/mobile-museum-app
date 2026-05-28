# mobile-museum-app

> 掌上博物馆 · 于方寸屏幕之间，唤醒沉睡千年的文明回响。

本项目是基于 HarmonyOS / ArkTS / ArkUI 开发的移动端博物馆应用，围绕文物浏览、文物检索、语音导览、用户交互与内容审核等场景，构建一个面向移动端的“掌上博物馆”系统。

## 项目简介

本系统面向博物馆数字化展示与交互体验场景，主要实现以下功能：

- 文物浏览与详情展示
- 文物分类筛选、热度排序、年代排序
- 文本搜索、以图搜图、语音搜索
- 文物点赞、收藏、浏览记录
- 用户登录注册与个人信息管理
- 用户评论、上传内容与审核流程
- 语音导览与语音问答模拟

## 技术栈

| 技术 | 说明 |
| --- | --- |
| HarmonyOS | 移动端应用运行平台 |
| ArkTS | 应用主要开发语言 |
| ArkUI | 声明式 UI 开发框架 |
| DevEco Studio | HarmonyOS 官方开发工具 |
| Git / GitHub | 项目版本管理与团队协作 |

## 功能模块

### 文物浏览

用户可以查看文物图片、名称、朝代、分类、热度和简介，并进入详情页查看完整信息。

### 搜索中心

搜索中心支持三种方式：

- 文本搜索：根据名称、朝代、类型、关键词检索文物。
- 以图搜图：模拟上传图片或实时拍照后返回相似文物。
- 语音搜索：模拟语音识别并提取关键词进行搜索。

### 语音导览

文物详情页提供语音导览交互：

- 播放 / 暂停
- 倍速选择
- 语音问答模拟

当前语音功能为前端模拟版，后续可接入 HarmonyOS AVPlayer 或语音识别服务实现真实音频播放与语音交互。

### 用户系统

支持用户登录、注册、退出登录，并提供个人信息管理功能：

- 查看账号信息
- 修改昵称、手机号、邮箱
- 切换隐私状态
- 查看收藏、点赞、浏览记录、上传数量

### 点赞收藏

用户登录后可以点赞和收藏文物，并在收藏页查看个人收藏内容。

### 评论审核

用户登录后可以发表评论。评论默认进入待审核状态，审核通过后才会展示在文物详情页。

### 上传内容审核

用户可以提交文物相关上传内容，包括关联文物、拍摄地点和说明。上传内容默认进入待审核状态，管理员可进行通过或驳回。

## 数据模型设计

当前版本采用前端模拟数据与 HarmonyOS Preferences 轻量持久化相结合的方式，实现登录状态、点赞收藏、浏览记录、上传记录和审核状态的本地保存。若后续接入后端服务，可按以下数据表进行扩展：

| 数据表 | 主要字段 | 说明 |
| --- | --- | --- |
| user | id、account、username、phone、email、role、privacyVisible | 保存用户账号、身份角色和隐私状态 |
| relic | id、name、dynasty、type、hot、intro、imageUrl | 保存文物基础信息、图片路径和热度 |
| favorite_group | id、userId、name | 保存用户自定义收藏夹分组 |
| favorite | id、userId、relicId、groupId、createdAt | 保存用户收藏记录 |
| like_record | id、userId、targetType、targetId、createdAt | 保存文物点赞和评论点赞记录 |
| browse_history | id、userId、relicId、viewedAt | 保存文物浏览记录 |
| comment | id、relicId、userId、content、parentId、status、createdAt | 保存评论、回复和审核状态 |
| user_upload | id、userId、relicName、location、description、imageUrl、status | 保存用户上传照片及审核状态 |
| audit_log | id、auditorId、targetType、targetId、result、createdAt | 保存审核员的审核操作记录 |

本项目在 `MuseumStore.ets` 中集中维护状态，便于页面共享；在入口页初始化本地 Preferences，保证用户刷新或重新进入应用后仍能恢复主要操作数据。

## 项目结构

```text
mobile-museum-app
├── AppScope/
├── entry/
│   └── src/
│       └── main/
│           ├── ets/
│           │   ├── model/
│           │   │   ├── MuseumModels.ets
│           │   │   └── MuseumStore.ets
│           │   └── pages/
│           │       ├── Index.ets
│           │       ├── RelicBrowsePage.ets
│           │       ├── FavoritePage.ets
│           │       ├── HistoryPage.ets
│           │       ├── SearchPage.ets
│           │       └── MinePage.ets
│           └── resources/
│               └── base/
│                   └── media/
├── oh-package.json5
├── hvigorfile.ts
├── build-profile.json5
├── .gitignore
└── README.md
