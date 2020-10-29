#!/system/bin/sh

# Pixel Power HAL Boot tools
# Writen by Yuhan Zhang <yuhan@rsyhan.me>
# Copyright (C) 2019-2020 Pikachu Technologies Lab <yuhan@rsyhan.me>

# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# sleep 30

# yuhan@maintainer<yuhan@rsyhan.me>, Detect whether Unlocked into System
while $(dumpsys window policy | grep mIsShowing | awk -F= '{print $2}')
do
sleep 1
done

# Kill SELinux
# setenforce 0

for i in /sys/block/*/queue; do
  echo 0 > $i/iostats;
done;

# Pixel Power HAL Changes Started
# yuhan@rsyhan.me, Yuhan Hack for booting pixel power hal 2020/1/29
# Neccessary to disable qti perf boost hal to make pixel power hal works more better
#stop perf-hal-1-0
#stop perf-hal-2-0

# Kill system's Power HAL
# Use Pixel's instead
stop vendor.power-hal-1-2
stop vendor.power-hal-1-0

# Init Power HAL
# Without this hal will waiting for it
setprop vendor.powerhal.init 1

# Start Pixel's Power HAL and Power stat HAL in a moment to stop display stucking
/vendor/bin/hw/android.hardware.power@1.3-service.pixel-libperfmgr | /vendor/bin/hw/android.hardware.power.stats@1.0-service.pixel
# Boot ended but this process may stuck here. No influence.
