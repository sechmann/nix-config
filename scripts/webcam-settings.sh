#!/usr/bin/env bash
dev=$(v4l2-ctl --list-devices | grep 'HD Pro Webcam C920' -A 1 | tail -n 1 | tr -d '[:space:]')
v4l2-ctl -d "$dev" -c 'focus_automatic_continuous=0'
v4l2-ctl -d "$dev" -c 'focus_absolute=0'
