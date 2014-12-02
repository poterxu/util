m=1
while [ $m -le 2 ]
do
adb shell input tap 162 339
sleep 5
adb shell input tap 977 1763
sleep 5
adb shell input keyevent 3
sleep 1
done
