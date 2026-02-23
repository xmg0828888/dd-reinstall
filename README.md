# DD 重装系统脚本

一键 DD 重装 Linux 系统，支持多发行版。

## 一键使用

```bash
bash <(curl -sL https://cdn.jsdelivr.net/gh/xmg0828888/dd-reinstall@main/dd-reinstall.sh)
```

## 支持系统

- Debian 13 / 12
- Ubuntu 24.04 / 22.04
- CentOS 9
- Alpine 3.19

## 功能

- ✅ 交互式配置（主机名/密码/端口/时区/Swap）
- ✅ 回车使用默认值，支持自定义
- ✅ 自动识别网络配置
- ✅ 可选 BBR 加速
- ✅ 多系统可选

## 默认配置

| 项目 | 默认值 |
|------|--------|
| 系统 | Debian 13 |
| SSH端口 | 22 |
| 密码 | Mng@2026DD! |
| 时区 | Asia/Hong_Kong |
| Swap | 1024MB |
| BBR | 开启 |
