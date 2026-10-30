#!/bin/sh
#
# Copyright (C) 2026 chargebyte GmbH
#

[ "$SERVICE_RESULT" = success ] && exit 0

. /lib/led.sh

MODEL=$(tr -d '\0' < /proc/device-tree/model)

case "$MODEL" in
"chargebyte AC Power board")
	LED="rgb:status"
	;;
*)
	exit 0
	;;
esac

rgbled_set_color "$LED" red
