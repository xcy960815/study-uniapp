# Docker 部署指南

## 📋 项目概述

Study UniApp 学习项目 H5 版本的 Docker 化部署方案，支持快速构建、部署和扩展。

## 🏗️ 项目结构

```
.
├── Dockerfile              # Docker 镜像构建文件
├── docker-compose.yml      # Docker Compose 编排文件
├── nginx-docker.conf       # Nginx 配置文件 (容器专用)
├── nginx.conf              # Nginx 配置文件 (完整版)
├── .dockerignore           # Docker 构建忽略文件
├── build-docker.sh         # 自动化构建脚本
└── DOCKER.md               # 本文档
```

## 🚀 快速开始

### 方式一：使用构建脚本 (推荐)

```bash
# 构建并测试
./build-docker.sh

# 构建指定版本
./build-docker.sh 1.0.0

# 构建并推送到指定仓库
./build-docker.sh 1.0.0 your-registry
```

### 方式二：手动构建

```bash
# 1. 构建镜像
docker build -t study-uniapp:latest .

# 2. 运行容器
docker run -d -p 8080:80 --name study-uniapp study-uniapp:latest

# 3. 访问应用
open http://localhost:8080
```

### 方式三：使用 Docker Compose

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

## 📦 镜像特性

### 多阶段构建优化
- **第一阶段**: 使用 Node.js 18 Alpine 构建前端资源
- **第二阶段**: 使用 Nginx Alpine 提供静态文件服务
- **最终镜像**: 仅包含运行时必需文件，大小约 30MB

### 性能优化
- **Gzip 压缩**: 启用多种文件类型压缩
- **静态资源缓存**: 长期缓存策略 (1年)
- **HTML 禁用缓存**: 确保应用更新及时生效
- **健康检查**: 内置健康检查机制

### 安全加固
- **非 root 用户**: 使用 nginx 用户运行
- **安全头设置**: X-Frame-Options, CSP 等
- **隐藏文件保护**: 禁止访问 .* 文件
- **版本信息隐藏**: 隐藏 Nginx 版本

## 🔧 配置说明

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| TZ | Asia/Shanghai | 时区设置 |

### 端口映射

| 容器端口 | 宿主机端口 | 说明 |
|----------|------------|------|
| 80 | 8080 | HTTP 服务端口 |

### 数据卷

| 容器路径 | 说明 |
|----------|------|
| /var/log/nginx | Nginx 日志目录 |
| /usr/share/nginx/html | 静态文件目录 |

## 🌐 访问地址

| 地址 | 说明 |
|------|------|
| http://localhost:8080 | 主应用 |
| http://localhost:8080/health | 健康检查 |
| http://localhost:8080/robots.txt | SEO 配置 |

## 🔍 监控与维护

### 健康检查
```bash
# 检查容器状态
docker ps

# 健康检查接口
curl http://localhost:8080/health
```

### 日志查看
```bash
# 查看容器日志
docker logs study-uniapp

# 查看 Nginx 访问日志
docker exec study-uniapp tail -f /var/log/nginx/access.log

# 查看 Nginx 错误日志
docker exec study-uniapp tail -f /var/log/nginx/error.log
```

### 性能监控
```bash
# 查看资源使用情况
docker stats study-uniapp

# 查看容器详细信息
docker inspect study-uniapp
```

## 🚀 生产部署

### 1. 镜像推送
```bash
# 标记镜像
docker tag study-uniapp:latest your-registry/study-uniapp:v1.0.0

# 推送镜像
docker push your-registry/study-uniapp:v1.0.0
```

### 2. 服务器部署
```bash
# 拉取镜像
docker pull your-registry/study-uniapp:v1.0.0

# 运行服务
docker run -d \
  --name study-uniapp \
  --restart unless-stopped \
  -p 80:80 \
  -v /var/log/nginx:/var/log/nginx \
  your-registry/study-uniapp:v1.0.0
```

### 3. 负载均衡配置 (Nginx)
```nginx
upstream uniapp-backend {
    server 127.0.0.1:8080;
    # server 127.0.0.1:8081; # 多实例负载均衡
}

server {
    listen 80;
    server_name your-domain.com;
    
    location / {
        proxy_pass http://uniapp-backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

## 🔄 持续集成

### GitHub Actions 示例
```yaml
name: Build and Deploy

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Docker image
        run: |
          docker build -t ${{ secrets.REGISTRY }}/study-uniapp:${{ github.sha }} .
          
      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker push ${{ secrets.REGISTRY }}/study-uniapp:${{ github.sha }}
```

## 🛠️ 故障排查

### 常见问题

#### 1. 容器启动失败
```bash
# 查看详细错误
docker logs study-uniapp

# 检查配置文件
docker exec study-uniapp nginx -t
```

#### 2. 静态资源 404
```bash
# 检查文件是否存在
docker exec study-uniapp ls -la /usr/share/nginx/html/

# 检查权限
docker exec study-uniapp ls -la /usr/share/nginx/html/
```

#### 3. API 代理失败
- 检查后端服务是否可达
- 确认网络配置正确
- 查看 nginx 错误日志

#### 4. 内存占用过高
- 调整 worker 进程数
- 优化 gzip 配置
- 使用多阶段构建减小镜像大小

## 📝 注意事项

1. **后端 API 地址**: 确保 `nginx-docker.conf` 中的 API 代理地址正确
2. **跨域配置**: 已预配置 CORS 支持
3. **缓存策略**: 生产环境建议配置 CDN
4. **SSL 证书**: 生产环境建议使用 HTTPS
5. **监控告警**: 建议配置监控和告警系统

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 📄 许可证

MIT License
