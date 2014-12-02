input tap 525 290
sleep 2
input tap 221 105
sleep 2
#adb shell sendevent /dev/input/event0 3 0 523 
#adb shell sendevent /dev/input/event0 3 1 1792
#adb shell sendevent /dev/input/event0 1 330 1
#adb shell sendevent /dev/input/event0 0 0 0  
#sleep 2
#adb shell sendevent /dev/input/event0 1 330 0 
#adb shell sendevent /dev/input/event0 0 0 0  
#adb shell input tap 523 1792

n="on"
m=1
sleep 10
while [ $m -le 2 ]
do
if [[ "$n" == "off" ]]; then
exit 1
fi
n=$(cat /sys/class/batt_switch/battery_switch_dev/sw_ctrl_2nd_batt_switch)
echo $n
input tap 523 1792 
done
