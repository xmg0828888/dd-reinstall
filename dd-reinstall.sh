#!/bin/bash
# DD 重装系统 - 引导脚本
# 一键: bash <(curl -sL mjjtop.com/dd)
# 下载脚本到本地再执行，避免管道模式 stdin 冲突

set -e
SCRIPT_URL="https://mjjtop.com/admin/dd-reinstall/raw/branch/main/dd-core.sh"

if command -v wget &>/dev/null; then
  wget --no-check-certificate -qO /tmp/dd-reinstall.sh "$SCRIPT_URL"
elif command -v curl &>/dev/null; then
  curl -fsSL -o /tmp/dd-reinstall.sh "$SCRIPT_URL"
else
  echo "错误: 需要 wget 或 curl" && exit 1
fi

chmod +x /tmp/dd-reinstall.sh
bash /tmp/dd-reinstall.sh
