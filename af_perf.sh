#!/bin/bash
#OPEN CAMERA
echo "af check start..." > log
adb shell input tap 554 303
sleep 10
#TOUCH AF CHECK
for i in {1..5}
do
adb shell input tap 553 871
sleep 2
echo "$i> touch af: " >> log
adb shell cat /sys/class/i2c-dev/i2c-4/device/4-003e/m10mo_af_status  >> log
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
