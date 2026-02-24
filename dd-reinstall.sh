#!/bin/bash
# DD 重装系统 - 引导脚本
# 一键: bash <(curl -sL mjjtop.com/dd)
# 下载核心脚本到本地再 exec 执行，彻底释放 stdin

CORE_URL="https://mjjtop.com/admin/dd-reinstall/raw/branch/main/dd-core.sh"
TMP="/tmp/dd-core-$$.sh"

if command -v wget &>/dev/null; then
  wget --no-check-certificate -qO "$TMP" "$CORE_URL"
elif command -v curl &>/dev/null; then
  curl -fsSL -o "$TMP" "$CORE_URL"
else
  echo "错误: 需要 wget 或 curl" && exit 1
fi

chmod +x "$TMP"
exec bash "$TMP"
