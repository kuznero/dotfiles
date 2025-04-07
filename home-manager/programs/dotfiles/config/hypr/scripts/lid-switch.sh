#!/usr/bin/env bash

ENABLE_MONITOR=$1
DISABLE_MONITOR=$2

if grep open /proc/acpi/button/lid/LID/state; then
	hyprctl keyword monitor "${ENABLE_MONITOR}"
else
	if [[ $(hyprctl monitors | grep "Monitor" | wc -l) != 1 ]]; then
		hyprctl keyword monitor "${DISABLE_MONITOR}"
	fi
fi
