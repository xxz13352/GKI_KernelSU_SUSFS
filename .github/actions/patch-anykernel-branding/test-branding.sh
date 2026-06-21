#!/system/bin/sh
# 测试自定义 AnyKernel3 品牌输出
# 在 Recovery / Termux / Linux 下均可运行

# 直接读取 prop，不存在则输出占位
safe_getprop() {
  if getprop "$1" >/dev/null 2>&1; then
    getprop "$1"
  else
    echo "[未检测到]"
  fi
}

# 读取内核版本
kernel_version() {
  if [ -r /proc/version ]; then
    awk '{print $3}' /proc/version
  else
    echo "[未检测到]"
  fi
}

echo " "
echo "欢迎使用 酷狗贼 Vivo/IQOO 独家定制内核"
echo "本内核为 酷安@酷狗贼 定制内核"
echo "酷狗贼 独家内核 禁止任何形式的帮刷/代刷"
echo "QQ:1423760291"
echo " "
echo "当前时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "机型名: $(safe_getprop ro.vivo.market.name)"
echo "系统版本: $(safe_getprop ro.build.version.bbk)"
echo "内核版本: $(kernel_version)"
echo " "
echo "当前刷入的内核版本为: $(kernel_version)"
echo " "
echo "请你生活玩机顺利，不下载执行未知来源的模块和.sh"
echo " "
