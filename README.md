# Study UniApp - 小兔鲜儿电商项目

## 📝 项目简介

本项目是一个基于 **uni-app** 框架开发的跨平台电商学习项目（小兔鲜儿），由 [Megasu/study-uniapp-vue3-ts](https://gitcode.com/Megasu/study-uniapp-vue3-ts/) Fork 并进行持续优化。

通过**条件编译**，本项目完美兼容 **H5 端**、**微信小程序端** 和 **App 端 (Android/iOS)**。

### 🚀 核心技术栈

- **框架**: [uni-app](https://uniapp.dcloud.net.cn/) (Vue3 + TypeScript + Vite)
- **状态管理**: [Pinia](https://pinia.vuejs.org/zh/) (集成持久化插件)
- **UI 组件库**: [uni-ui](https://uniapp.dcloud.net.cn/component/uniui/uni-ui.html)
- **部署**: Docker + Nginx

---

## 📦 功能模块

- **首页模块**: 轮播图、面板展示、热门推荐。
- **分类模块**: 多级分类浏览。
- **商品详情**: SKU 选择、商品参数、详情展示。
- **购物车**: 加入购物车、数量编辑、合并结算。
- **会员中心**: 微信一键登录、个人信息管理、收货地址管理。
- **订单系统**: 创建订单、支付流程、订单列表、详情追踪。

---

## 🛠️ 开发与运行

### 1. 环境准备

- **Node 版本**: v18+
- **包管理器**: pnpm (推荐)

### 2. 安装依赖

```shell
pnpm install
```

### 3. 本地开发

```shell
# 微信小程序端
pnpm run dev:mp-weixin

# H5 端
pnpm run dev:h5

# App 端
需使用 HBuilderX 工具，选择“运行 - 运行到手机或模拟器”
```

---

## 🐳 Docker 部署

本项目已完成深度容器化配置，支持一键部署。

### 1. 快速启动

```shell
# 使用 Docker Compose 一键启动
docker-compose up -d
```

启动后访问：`http://localhost:9527`

### 2. 自动化构建

可以使用内置脚本进行镜像构建：

```shell
./build-docker.sh [版本号]
```

更多 Docker 详细配置请参考：[DOCKER.md](./DOCKER.md)

---

## 📂 项目结构

```text
├── .github/workflows          # GitHub Actions 自动化部署
├── src/
│   ├── components             # 全局公共组件
│   ├── pages/                 # 主包页面 (首页、分类、购物车、我的)
│   ├── pagesMember/           # 会员分包
│   ├── pagesOrder/            # 订单分包
│   ├── services/              # API 请求封装
│   ├── stores/                # Pinia 状态管理
│   ├── types/                 # TypeScript 类型定义
│   └── utils/                 # 工具函数
├── docker-compose.yml         # Docker 编排配置
├── Dockerfile                 # 镜像构建配置
└── nginx-docker.conf          # 容器专用 Nginx 配置
```

---

## 🔗 相关资源

- **原作者项目**: [Megasu/study-uniapp-vue3-ts](https://gitcode.com/Megasu/study-uniapp-vue3-ts/)
- **配套视频**: [Bilibili 教程](https://www.bilibili.com/video/BV1Bp4y1379L/)
- **接口文档**: [Apifox 文档](https://www.apifox.cn/apidoc/shared-0e6ee326-d646-41bd-9214-29dbf47648fa/)

---

## 📄 许可证

[MIT License](./LICENSE)
