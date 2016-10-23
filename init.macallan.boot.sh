#!/system/bin/sh

# set persistent FPS limits
setprop persist.sys.NV_FPSLIMIT 30;
setprop persist.tegra.NV_FPSLIMIT 30;

# set alsa volume maximum
alsa_amixer sset HP 31;
alsa_amixer sset Speaker 31;

# persist adb disabled off
setprop persist.service.adb.enable 0;

# internet parameters
echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;

# vm parameters
echo "500" > /proc/sys/vm/dirty_expire_centisecs;
echo "1000" > /proc/sys/vm/dirty_writeback_centisecs;
echo "0" >  /proc/sys/vm/swappiness;
echo "50" > /proc/sys/vm/vfs_cache_pressure;
echo "0" > /proc/sys/vm/page-cluster
echo "4194304" >  /proc/sys/vm/dirty_background_bytes;
echo "4194304" > /proc/sys/vm/dirty_bytes;

# i/o scheduler
echo "deadline" > /sys/block/mmcblk0/queue/scheduler;
echo "0" > /sys/block/mmcblk0/queue/iosched/fifo_batch;
echo "0" > /sys/block/mmcblk0/queue/iosched/front_merges;
echo "350" > /sys/block/mmcblk0/queue/iosched/read_expire;
echo "3500" > /sys/block/mmcblk0/queue/iosched/write_expire;
echo "6" > /sys/block/mmcblk0/queue/iosched/writes_starved;
echo "2" > /sys/block/mmcblk0/queue/nomerges;
echo "2" > /sys/block/mmcblk0/queue/rq_affinity;

# cpuquiet
echo "70" > /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/up_delay;
echo "500" > /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/down_delay;
echo "306000" > /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/idle_bottom_freq;
echo "696000" > /sys/devices/system/cpu/cpuquiet/tegra_cpuquiet/idle_top_freq;
echo "0" > /sys/devices/system/cpu/cpuquiet/balanced/balance_level;
echo "500" > /sys/devices/system/cpu/cpuquiet/balanced/down_delay;
echo "306000" >/sys/devices/system/cpu/cpuquiet/balanced/idle_bottom_freq;
echo "2116500" > /sys/devices/system/cpu/cpuquiet/balanced/idle_top_freq;
echo "15" > /sys/devices/system/cpu/cpuquiet/balanced/load_sample_rate;
echo "1" > /sys/devices/system/cpu/cpuquiet/balanced/up_delay;

# uksm
echo "0" > /sys/kernel/mm/uksm/run;
echo "500" > /sys/kernel/mm/uksm/sleep_millisecs;

# zram
for i in 0 1 2 3
do
  swapoff /dev/block/zram$i > /dev/null 2>&1;
  echo "1" > /sys/block/zram$i/reset;
  echo "268435456" > /sys/block/zram$i/disksize;
  mkswap /dev/block/zram$i > /dev/null 2>&1;
  swapon -p 10 /dev/block/zram$i > /dev/null 2>&1;
done

# touchscreen calibration
cat /sys/bus/i2c/drivers/fts_ts/1-0038/ftsclb;
cat /sys/bus/i2c/drivers/fts_ts/1-0038/ftsuniformity;

# disable hardware overlays
while :
do
    sf=$(service list | grep -c "SurfaceFlinger")
    if [ $sf -eq 1 ]
    then
        service call SurfaceFlinger 1008 i32 1
        break
    else
        sleep 2
    fi
done
