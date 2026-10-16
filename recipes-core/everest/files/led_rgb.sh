#!/bin/sh
#
# Copyright (C) 2026 chargebyte GmbH 
#
# Script to control RGB LED
#

. /lib/led.sh

MODEL=$(tr -d '\0' < /proc/device-tree/model)

case "$MODEL" in
"chargebyte AC Power board")
	LED_RGB="rgb:status"
	;;
*)
	exit 0
esac

MAXBRIGHTNESS="$(led_get_attr "$LED_RGB" "max_brightness")"

case "$1" in
"")
	led_get_attr "$LED_RGB" "multi_intensity"
	exit 0
	;;
"black")
	led_set_attr "$LED_RGB" "multi_intensity" "0 0 0 0"
	led_set_attr "$LED_RGB" "brightness" "0"
	;;
"white")
	led_set_attr "$LED_RGB" "multi_intensity" "0 0 0 $MAXBRIGHTNESS"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
	;;
"red")
	led_set_attr "$LED_RGB" "multi_intensity" "$MAXBRIGHTNESS 0 0 0"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
	;;
"yellow")
	led_set_attr "$LED_RGB" "multi_intensity" "$MAXBRIGHTNESS $MAXBRIGHTNESS 0 0"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
	;;
"green")
	led_set_attr "$LED_RGB" "multi_intensity" "0 $MAXBRIGHTNESS 0 0"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
	;;
"purple")
	led_set_attr "$LED_RGB" "multi_intensity" "$MAXBRIGHTNESS 0 $MAXBRIGHTNESS 0"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
	;;
"blue")
	led_set_attr "$LED_RGB" "multi_intensity" "0 0 $MAXBRIGHTNESS 0"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
	;;
*)
	echo "Unknown color"
	exit 1
esac

if [[ $# -eq 2 ]]; then
	case "$2" in
	"pulse")
		led_set_attr "$LED_RGB" "trigger" "pattern"
		led_set_attr "$LED_RGB" "pattern" "0 1000 255 1000"
		;;
	"blink")
		led_set_attr "$LED_RGB" "trigger" "timer"
		led_set_attr "$LED_RGB" "delay_on" "500"
		led_set_attr "$LED_RGB" "delay_off" "500"
		;;
	*)
		echo "Unknown parameter"
		exit 1
	esac
else
	led_set_attr "$LED_RGB" "trigger" "none"
	led_set_attr "$LED_RGB" "brightness" "$MAXBRIGHTNESS"
fi
