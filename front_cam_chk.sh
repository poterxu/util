#!/bin/bash
#OPEN CAMERA
m=1
n=0
while [ $m -le 2 ]
do
#adb shell input tap 984 87
#sleep 1
if [[ $n -eq 1000 ]]; then
sleep 10
adb shell rm -rf /sdcard/DCIM
sleep 20
n=0
fi
let "n += 1"
#echo $n
adb shell input tap 509 1775
#sleep 1
#adb shell input tap 984 87
#sleep 1
done

#CLOSE CAMERA
#adb shell input keyevent 4
#for i in {1..5}
#do
#adb shell input tap 554 303
#sleep 10
#echo "$i> caf: " >> log
#adb shell cat /sys/class/i2c-dev/i2c-4/device/4-003e/m10mo_af_status  >> log
#adb shell input keyevent 4
#done
