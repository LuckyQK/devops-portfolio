#!/bin/bash
# ==========================================
# 郑州运维转岗实战 - Day 7 智能告警与定时巡检
# ==========================================

CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")
HOSTNAME=$(hostname)

# 1. 获取带百分号的原始展示数据
DISK_USAGE_STR=$(df -h / | awk 'NR==2 {print $5}')
MEM_USAGE_STR=$(free -m | awk 'NR==2 {printf "%.0f%%", $3/$2*100}')
CPU_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | sed 's/ //g')

# 2. 获取纯数字用于 if 判断 (剔除 % 号)
DISK_NUM=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//g')
MEM_NUM=$(free -m | awk 'NR==2 {printf "%.0f", $3/$2*100}')

echo -e "\033[36m======================================\033[0m"
echo -e "\033[33m 🚀 服务器日常巡检报告 \033[0m"
echo -e " \033[36m时间:\033[0m $CURRENT_TIME  \033[36m主机:\033[0m $HOSTNAME"
echo -e "\033[36m--------------------------------------\033[0m"
echo -e " \033[36m[CPU]\033[0m 1分钟负载 : $CPU_LOAD"

# 3. 内存告警判断 (阈值 80%)
if [ "$MEM_NUM" -ge 80 ]; then
    echo -e " \033[31m[内存] 🚨 严重告警: 已用 $MEM_USAGE_STR (超80%)\033[0m"
else
    echo -e " \033[32m[内存] ✅ 状态正常: 已用 $MEM_USAGE_STR\033[0m"
fi

# 4. 磁盘告警判断 (阈值 80%)
if [ "$DISK_NUM" -ge 80 ]; then
    echo -e " \033[31m[磁盘] 🚨 严重告警: 根分区已用 $DISK_USAGE_STR (超80%)\033[0m"
else
    echo -e " \033[32m[磁盘] ✅ 状态正常: 根分区已用 $DISK_USAGE_STR\033[0m"
fi
echo -e "\033[36m======================================\033[0m"
