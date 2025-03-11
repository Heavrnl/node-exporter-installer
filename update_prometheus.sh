#!/bin/bash
set -e
set -o pipefail

# 提示用户输入目标 IP 和实例名称
read -p "请输入目标 IP : " TARGET_IP
read -p "请输入实例名称 : " INSTANCE_NAME

# 默认端口 9100
FULL_TARGET="${TARGET_IP}:9100"

# Prometheus 配置文件路径
CONFIG_FILE="/etc/prometheus/prometheus.yml"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "配置文件 $CONFIG_FILE 不存在，请检查！"
    exit 1
fi

echo "正在更新配置文件 $CONFIG_FILE ..."

# 使用 sed 在第一处出现 static_configs: 后追加新条目
sed -i "/static_configs:/a \      - targets: ['$FULL_TARGET']\n        labels:\n          instance: \"$INSTANCE_NAME\"" "$CONFIG_FILE"

echo "配置文件更新完成，正在重启 Prometheus 服务..."

# 重启 Prometheus 服务
systemctl restart prometheus

echo "Prometheus 服务已重启。"
