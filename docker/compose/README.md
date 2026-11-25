# 小兔鲜儿 H5 部署

在同目录的 `.env` 中配置部署参数。默认将宿主机的 9527 端口映射到容器的 80 端口，健康检查路径为 `/health`。

| 变量 | 作用 |
| --- | --- |
| `STUDY_UNIAPP_IMAGE` | 镜像名和版本标签 |
| `CONTAINER_NAME` | 容器名 |
| `PORT_WEB` | 宿主机 HTTP 端口 |
| `TZ` | 容器时区 |
| `LOG_DIR_PATH` | 挂载到容器 `/var/log/nginx` 的宿主机目录 |
| `NETWORK_NAME` | 独立 bridge 网络的名称 |

## 启动与更新

部署前核对 `LOG_DIR_PATH`。默认值沿用项目原有日志路径；使用 `/data/apps` 数据盘的宿主机可在 `.env` 中改为 `/data/apps/study-uniapp/logs`。切换路径时如需保留历史日志，请先复制到新目录。

在本目录执行以下命令。Compose 自动读取同目录的 `.env`。使用 DPanel 时，同时导入编排文件和完整的 `.env`。

```sh
docker compose -f study-uniapp-compose.yml config -q
docker compose -f study-uniapp-compose.yml pull
docker compose -f study-uniapp-compose.yml up -d
docker compose -f study-uniapp-compose.yml ps
```

按默认端口部署后，在宿主机访问 `http://localhost:9527/health` 可检查服务。部署新版本时，先发布镜像，更新 `STUDY_UNIAPP_IMAGE` 后重新执行 pull 和 up。
