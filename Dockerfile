# 多阶段构建 Dockerfile for UniApp 小兔鲜儿商城

# ================================
# 第一阶段：前端构建阶段
# ================================
FROM node:18-alpine AS frontend-builder

# 设置工作目录
WORKDIR /app

# 设置 npm 镜像源（可选，提高国内构建速度）
RUN npm config set registry https://registry.npmmirror.com

# 安装 pnpm
RUN npm install -g pnpm

# 复制 package 文件
COPY package.json pnpm-lock.yaml ./

# 安装依赖（利用 Docker 缓存层优化）
RUN pnpm install --frozen-lockfile

# 复制源代码
COPY . .

# 清理可能存在的构建产物
RUN rm -rf dist node_modules/.cache

# 构建 H5 生产环境
RUN pnpm run build:h5

# ================================
# 第二阶段：Nginx 服务阶段
# ================================
FROM nginx:1.25-alpine

# 设置维护者信息
LABEL maintainer="18763006837@163.com"

LABEL description="study-uniapp"

# 安装必要工具
RUN apk add --no-cache tzdata

# 设置时区
ENV TZ=Asia/Shanghai

# 容器监听端口
EXPOSE 80

# 创建应用目录
WORKDIR /app

# 复制 nginx 配置文件
COPY nginx-docker.conf /etc/nginx/conf.d/default.conf

# 创建日志目录
RUN mkdir -p /var/log/nginx

# 清理默认文件并创建新的 html 目录
RUN rm -rf /usr/share/nginx/html/* && \
    mkdir -p /usr/share/nginx/html

# 从构建阶段复制构建产物
COPY --from=frontend-builder /app/dist/build/h5 /usr/share/nginx/html/

# 创建健康检查脚本
RUN echo '#!/bin/sh' > /healthcheck.sh && \
    echo 'curl -f http://localhost/health || exit 1' >> /healthcheck.sh && \
    chmod +x /healthcheck.sh

# 添加健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD /healthcheck.sh

# 创建启动脚本
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "Starting UniApp H5 application..."' >> /start.sh && \
    echo 'echo "Build time: $(date)"' >> /start.sh && \
    echo 'nginx -t && nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

# 使用非 root 用户运行（安全考虑）
RUN chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

# 启动服务
CMD ["/start.sh"]

# ================================
# 构建命令示例
# ================================
# 开发环境构建：
# docker build -t study-uniapp:dev .
#
# 生产环境构建：
# docker build -t study-uniapp:latest .
# docker build -t <your-account>/study-uniapp:1.0.0 .
#
# 运行容器：
# docker run -d -p 80:80 --name study-uniapp study-uniapp:latest
#
# 推送到仓库：
# docker push <your-account>/study-uniapp:1.0.0
