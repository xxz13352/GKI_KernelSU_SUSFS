#!/system/bin/sh
# 模拟 anykernel.sh 格式，测试自定义品牌输出
# 在 Recovery / Termux / Linux 下均可运行

# mock Recovery 函数，非 Recovery 环境也能直接看到输出
ui_print() { echo "$@"; }
abort() { echo "$@"; exit 1; }
split_boot() { :; }
unpack_ramdisk() { :; }
write_boot() { :; }
flash_boot() { :; }
SPLITIMG="/tmp/splitimg"
AKHOME="/tmp/akhome"
mkdir -p "$SPLITIMG" "$AKHOME"
# 构造一个假 Image，用于测试"正在刷入的内核版本"读取
printf 'Linux version 6.1.141-android14-test-flash (build-user@build-host) (Clang something)\n' > "$AKHOME/Image"

get_root_type() {
    if [ -f /data/adb/magisk/util_functions.sh ]; then
        local magisk_ver=$(magisk -v 2>/dev/null | head -n 1)
        echo "Magisk (${magisk_ver})"
    elif [ -f /data/adb/ksud ]; then
        local ksu_ver=$(ksud -V 2>/dev/null | head -n 1)
        echo "KernelSU (${ksu_ver})"
    elif [ -f /data/adb/apatch ]; then
        local apatch_ver=$(apatch -v 2>/dev/null | head -n 1)
        echo "APatch (${apatch_ver})"
    else
        echo "未知Root环境"
    fi
}
get_device_brand() {
    getprop ro.product.brand
}
get_vivo_phone() {
    local brand=$(get_device_brand)
    case "$brand" in
      *vivo*|*iqoo*) dumpsys content 2>/dev/null | grep 'BBKOnLineService' | awk '{print $2}' | head -n 1 ;;
    esac
}
get_oplus_phone() {
    :
}

### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
### AnyKernel setup
# global properties
properties() { '
kernel.string=酷狗贼 Vivo/IQOO 独家定制内核 by 酷安@酷狗贼
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
do.check_boot_version=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1

# GKI check
kernel_version=$(cat /proc/version | awk -F '-' '{print $1}' | awk '{print $3}')
case $kernel_version in
 5.10*) ksu_supported=true ;;
 5.15*) ksu_supported=true ;;
 6.1*) ksu_supported=true ;;
 6.6*) ksu_supported=true ;;
 6.12*) ksu_supported=true ;;
 *) ksu_supported=false ;;
esac
ui_print " " "  -> 酷狗贼内核支持状态: $ksu_supported"
$ksu_supported || abort "  -> Non-GKI device, abort."

# boot install
split_boot

if [ -f "$SPLITIMG/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi

ui_print " "
ui_print "－ ●ROOT环境: $(get_root_type) ●"
ui_print "－ ●欢迎使用本模块！●"
phone=$(get_vivo_phone)
[ -z "$phone" ] && phone=$(get_oplus_phone)
[ -n "$phone" ] && ui_print "－ ●您的手机号: $phone ●"
ui_print " "
ui_print "欢迎使用 酷狗贼 Vivo/IQOO 独家定制内核"
ui_print "本内核为 酷安@酷狗贼 定制内核"
ui_print "酷狗贼 独家内核 禁止任何形式的帮刷/代刷"
ui_print "QQ:1423760291"
ui_print " "
ui_print "－ ●当前时间: $(date '+%Y-%m-%d %H:%M:%S') ●"
ui_print "－ ●机型名: $(getprop ro.vivo.market.name) ●"
ui_print "－ ●系统版本: $(getprop ro.build.version.bbk) ●"
ui_print "－ ●内核版本: $(cat /proc/version | awk '{print $3}') ●"
ui_print " "
flashed_kernel=$(strings "$AKHOME/Image" 2>/dev/null | grep -m1 '^Linux version ' | awk '{print $3}')
[ -z "$flashed_kernel" ] && flashed_kernel=$(cat /proc/version | awk '{print $3}')
ui_print "－ ●当前刷入的内核版本为: $flashed_kernel ●"
ui_print " "
ui_print "请你生活玩机顺利，不下载执行未知来源的模块和.sh"
ui_print " "
