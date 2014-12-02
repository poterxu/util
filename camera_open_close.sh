#!/bin/bash
for i in {1..10000}
do
adb shell input tap 500 300
sleep 2
adb shell input keyevent 4
done
