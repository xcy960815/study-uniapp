# H5 镜像构建与运行

在应用仓库根目录构建，Dockerfile 的第一阶段运行 `pnpm run build:h5`，第二阶段将静态产物复制到 Nginx。

```sh
docker build -t study-uniapp:local .
docker run --rm -p 8080:80 study-uniapp:local
```

浏览器打开 `http://localhost:8080`，健康检查地址为 `http://localhost:8080/health`。商城请求由浏览器直接发往前端配置的教学 API。

## 镜像配置

- `docker/nginx/default.conf` 由 Dockerfile 复制到镜像，配置静态文件、缓存和健康检查。
- `docker/nginx/nginx.conf` 是单独部署 Nginx 时的完整配置，使用前核对其中的后端代理地址。
- `scripts/build-docker.sh [版本号] [镜像命名空间]` 用于本地构建和检查，按交互提示可启动测试容器或推送镜像。
- 推送形如 `v1.2.3` 的版本标签会触发 GitHub Actions，为 amd64 和 arm64 构建并发布镜像。

## 服务器编排

本项目的 [Compose 部署目录](../docker/compose/README.md) 包含编排、配套 `.env` 和启动命令。发布镜像后，在该目录的 `.env` 中设置 `STUDY_UNIAPP_IMAGE` 即可选择要部署的版本。
