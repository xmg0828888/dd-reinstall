#!/bin/bash
# DD 重装系统 - Debian 13
# 用法: curl -sL mjjtop.com/dd -o dd.sh && bash dd.sh

set -e

# 颜色
R='\033[0;31m' G='\033[0;32m' Y='\033[0;33m' B='\033[0;34m' N='\033[0m'

echo -e "${B}╔══════════════════════════════════════╗${N}"
echo -e "${B}║     DD 重装系统 - Debian 13          ║${N}"
echo -e "${B}╚══════════════════════════════════════╝${N}"
echo

# 默认值
DEF_PWD="Mng@2026DD!"
DEF_PORT="22"
DEF_HOST="debian"
DEF_TZ="Asia/Hong_Kong"
DEF_SWAP="1024"

# 交互输入
read -p "$(echo -e ${G}主机名${N} [${DEF_HOST}]: )" MYHOST
MYHOST=${MYHOST:-$DEF_HOST}

read -p "$(echo -e ${G}SSH端口${N} [${DEF_PORT}]: )" MYPORT
MYPORT=${MYPORT:-$DEF_PORT}

read -sp "$(echo -e ${G}root密码${N} [默认: ${DEF_PWD}]: )" MYPWD
echo
MYPWD=${MYPWD:-$DEF_PWD}

read -p "$(echo -e ${G}时区${N} [${DEF_TZ}]: )" MYTZ
MYTZ=${MYTZ:-$DEF_TZ}

read -p "$(echo -e ${G}Swap大小MB${N} [${DEF_SWAP}]: )" MYSWAP
MYSWAP=${MYSWAP:-$DEF_SWAP}

read -p "$(echo -e ${G}启用BBR${N} [Y/n]: )" BBR
BBR=${BBR:-Y}

# 系统选择
echo
echo -e "${Y}选择系统:${N}"
echo "  1) Debian 13 (默认)"
echo "  2) Debian 12"
echo "  3) Ubuntu 24.04"
echo "  4) Ubuntu 22.04"
echo "  5) CentOS 9"
echo "  6) Alpine 3.19"
read -p "$(echo -e ${G}选择${N} [1]: )" OS_CHOICE
OS_CHOICE=${OS_CHOICE:-1}

case $OS_CHOICE in
  1) OS_FLAG="-debian 13" ;;
  2) OS_FLAG="-debian 12" ;;
  3) OS_FLAG="-ubuntu 24.04" ;;
  4) OS_FLAG="-ubuntu 22.04" ;;
  5) OS_FLAG="-centos 9" ;;
  6) OS_FLAG="-alpine 3.19" ;;
  *) OS_FLAG="-debian 13" ;;
esac

BBR_FLAG=""
[[ "${BBR,,}" != "n" ]] && BBR_FLAG="--bbr"

# 确认
echo
echo -e "${Y}════════ 确认配置 ════════${N}"
echo -e "  系统:   ${B}${OS_FLAG}${N}"
echo -e "  主机名: ${B}${MYHOST}${N}"
echo -e "  SSH端口: ${B}${MYPORT}${N}"
echo -e "  密码:   ${B}******${N}"
echo -e "  时区:   ${B}${MYTZ}${N}"
echo -e "  Swap:   ${B}${MYSWAP}MB${N}"
echo -e "  BBR:    ${B}${BBR_FLAG:-关闭}${N}"
echo -e "${Y}══════════════════════════${N}"
echo
read -p "$(echo -e ${R}确认重装? 数据将全部丢失!${N} [y/N]: )" CONFIRM
[[ "${CONFIRM,,}" != "y" ]] && echo "已取消" && exit 0

# 下载并执行
echo -e "${G}下载 InstallNET.sh ...${N}"
if command -v wget &>/dev/null; then
  wget --no-check-certificate -qO InstallNET.sh \
    'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh'
elif command -v curl &>/dev/null; then
  curl -fsSL -o InstallNET.sh \
    'https://raw.githubusercontent.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh'
else
  echo -e "${R}错误: 需要 wget 或 curl${N}" && exit 1
fi
chmod a+x InstallNET.sh

echo -e "${G}开始重装...${N}"
bash InstallNET.sh $OS_FLAG \
  -port "$MYPORT" \
  -pwd "$MYPWD" \
  -hostname "$MYHOST" \
  -timezone "$MYTZ" \
  -swap "$MYSWAP" \
  $BBR_FLAG

# 修复 GRUB timeout
GRUB_CFG="/boot/grub/grub.cfg"
if [ -f "$GRUB_CFG" ]; then
  if ! grep -q "^set timeout=" "$GRUB_CFG"; then
    sed -i '/^set default=/a set timeout=5' "$GRUB_CFG"
    echo -e "${G}已添加 GRUB timeout=5${N}"
  fi
fi

echo
echo -e "${Y}重装完成，10秒后自动重启...${N}"
for i in $(seq 10 -1 1); do
  echo -ne "\r${R}${i}${N} 秒后重启... (Ctrl+C 取消)"
  sleep 1
done
echo
reboot
