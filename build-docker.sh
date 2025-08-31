#!/bin/bash

# Study UniApp 学习项目 Docker 构建脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 项目信息
PROJECT_NAME="study-uniapp"
VERSION=${1:-"latest"}
REGISTRY=${2:-"xcy960815"}
IMAGE_NAME="${REGISTRY}/${PROJECT_NAME}"

echo -e "${BLUE}🚀 开始构建 Study UniApp 学习项目 Docker 镜像${NC}"
echo -e "${BLUE}项目名称: ${PROJECT_NAME}${NC}"
echo -e "${BLUE}版本标签: ${VERSION}${NC}"
echo -e "${BLUE}镜像名称: ${IMAGE_NAME}:${VERSION}${NC}"
echo ""

# 检查必要文件
echo -e "${YELLOW}📋 检查必要文件...${NC}"
required_files=("Dockerfile" "nginx-docker.conf" "package.json" ".dockerignore")
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ 缺少必要文件: $file${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ $file${NC}"
done
echo ""

# 清理之前的构建产物
echo -e "${YELLOW}🧹 清理之前的构建产物...${NC}"
rm -rf dist/build
echo -e "${GREEN}✅ 清理完成${NC}"
echo ""

# 构建 Docker 镜像
echo -e "${YELLOW}🔨 构建 Docker 镜像...${NC}"
docker build \
    --tag "${IMAGE_NAME}:${VERSION}" \
    --tag "${IMAGE_NAME}:latest" \
    --build-arg BUILDTIME="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg VERSION="${VERSION}" \
    .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker 镜像构建成功!${NC}"
else
    echo -e "${RED}❌ Docker 镜像构建失败!${NC}"
    exit 1
fi
echo ""

# 显示镜像信息
echo -e "${YELLOW}📊 镜像信息:${NC}"
docker images "${IMAGE_NAME}" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"
echo ""

# 检查镜像
echo -e "${YELLOW}🔍 检查镜像内容...${NC}"
docker run --rm "${IMAGE_NAME}:${VERSION}" ls -la /usr/share/nginx/html/
echo ""

# 询问是否启动测试容器
read -p "是否启动测试容器? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🚀 启动测试容器...${NC}"
    
    # 停止可能存在的容器
    docker stop "${PROJECT_NAME}-test" 2>/dev/null || true
    docker rm "${PROJECT_NAME}-test" 2>/dev/null || true
    
    # 启动新容器
    docker run -d \
        --name "${PROJECT_NAME}-test" \
        --publish 8080:80 \
        "${IMAGE_NAME}:${VERSION}"
    
    echo -e "${GREEN}✅ 测试容器已启动!${NC}"
    echo -e "${GREEN}🌐 访问地址: http://localhost:8080${NC}"
    echo -e "${GREEN}🔍 健康检查: http://localhost:8080/health${NC}"
    echo ""
    echo -e "${YELLOW}停止测试容器命令:${NC}"
    echo -e "${BLUE}docker stop ${PROJECT_NAME}-test && docker rm ${PROJECT_NAME}-test${NC}"
fi

# 询问是否推送到仓库
echo ""
read -p "是否推送镜像到仓库? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}📤 推送镜像到仓库...${NC}"
    
    docker push "${IMAGE_NAME}:${VERSION}"
    docker push "${IMAGE_NAME}:latest"
    
    echo -e "${GREEN}✅ 镜像推送完成!${NC}"
    echo -e "${GREEN}🐳 镜像地址: ${IMAGE_NAME}:${VERSION}${NC}"
fi

echo ""
echo -e "${GREEN}🎉 构建流程完成!${NC}"
echo ""
echo -e "${YELLOW}📝 使用说明:${NC}"
echo -e "${BLUE}# 运行容器${NC}"
echo -e "${BLUE}docker run -d -p 8080:80 --name ${PROJECT_NAME} ${IMAGE_NAME}:${VERSION}${NC}"
echo ""
echo -e "${BLUE}# 使用 Docker Compose${NC}"
echo -e "${BLUE}docker-compose up -d${NC}"
echo ""
echo -e "${BLUE}# 查看日志${NC}"
echo -e "${BLUE}docker logs ${PROJECT_NAME}${NC}"
