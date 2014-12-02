#!/bin/bash
adb shell input tap 796 497
adb shell input tap 768 897
adb shell input tap 783 1406
adb shell input tap 548 1260
adb shell input tap 548 900
adb shell input tap 548 376
adb shell input tap 220 418 
adb shell input tap 220 894
adb shell input tap 220 1342
for i in {1..10}
do
adb shell input tap 220 418 
done

for i in {1..10}
do
adb shell input tap 220 894 
done

for i in {1..10}
do
adb shell input tap 220 1342 
done
for j in {1..100}
do
for i in {1..5}
do
adb shell input tap 783 1406
done
adb shell input tap 529 1792
adb shell input tap 529 1792
sleep 2
done
