#!/bin/bash

#-----------------
#VARIABLE DEFITION
#-----------------
onetime="FALSE"
osd_on="FALSE"
module_vendor="FOXCONN"
forced_upgrade="FALSE"

#-----------------------
#PROCESS COMMAND OPTIONS
#-----------------------
while getopts "tdp:f:" opt; do
	case $opt in
	t)
		onetime="TRUE"
	;;
	d)

		osd_on="TRUE"
	;;
	p)

		path=$OPTARG
	;;
	f)

		forced_bin=$OPTARG
		forced_upgrade="TRUE"
	;;

	esac
done


#---------------------
#DECOMPRESS 7z package
#---------------------

module_vendor_multiline=$(adb shell head -n 2 /sys/class/i2c-dev/i2c-4/device/4-003e/functions)
if echo "$module_vendor_multiline" | grep -q "LITE_ON"; then
		version_property="persist.m10mo.l.version"
fi

if echo "$module_vendor_multiline" | grep -q "FOXCONN"; then
		version_property="persist.m10mo.f.version"
fi




if [[ "$forced_upgrade" == "TRUE" ]]; then
	if [ -f $forced_bin ]; then
		base_forced_bin=$(basename $forced_bin)
		adb remount
		adb push $forced_bin /system/
		adb shell /system/bin/isp_write s /system/$base_forced_bin
		updated_version=$(adb shell head -n 1 /sys/class/i2c-dev/i2c-4/device/4-003e/functions)
		echo "isp updated ${updated_version}"


		if [[ "$onetime" == "FALSE" ]]; then
			adb shell setprop $version_property $updated_version
		fi
	else
		echo "$forced_bin does not exist."
		exit 1
	fi
	exit 0

fi


SEVEN_Z_BASE_NAME=$(basename $path .7z)
echo ${SEVEN_Z_BASE_NAME}
pending_version=${SEVEN_Z_BASE_NAME:9:4}
echo ${pending_version}
7z -o./$SEVEN_Z_BASE_NAME x $path
echo $path
adb remount
adb push ./$SEVEN_Z_BASE_NAME/$SEVEN_Z_BASE_NAME /system/
adb push target_isp_fw_dl.sh /system/
adb shell chmod 777 /system/target_isp_fw_dl.sh
if [[ "$osd_on" == "TRUE" ]]; then
 if [[ "$onetime" == "TRUE" ]]; then
 adb shell /system/target_isp_fw_dl.sh -d -t -p RS_M10MO -l ${pending_version} -f ${pending_version}
else
adb shell /system/target_isp_fw_dl.sh -d -p RS_M10MO -l ${pending_version} -f ${pending_version}

fi
else
  if [[ "$onetime" == "TRUE" ]]; then
 adb shell /system/target_isp_fw_dl.sh  -t -p RS_M10MO -l ${pending_version} -f ${pending_version}
else
adb shell /system/target_isp_fw_dl.sh  -p RS_M10MO -l ${pending_version} -f ${pending_version}
fi
fi

rm -vrf ./$SEVEN_Z_BASE_NAME
