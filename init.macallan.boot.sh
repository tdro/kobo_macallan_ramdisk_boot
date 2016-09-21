#!/system/bin/sh

# set persistent FPS limits
setprop persist.sys.NV_FPSLIMIT 30;
setprop persist.tegra.NV_FPSLIMIT 30;

# set alsa volume maximum
alsa_amixer sset HP 31;
alsa_amixer sset Speaker 31;

# persist adb disabled off
setprop persist.service.adb.enable 0;

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
