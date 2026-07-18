#!/usr/bin/env bash

printf "\033[?25l"

stty -echo

clear

export MESA_SHADER_CACHE_DIR=/tmp/yGreeter/mesa

exec "$@" \
	> /tmp/yGreeter/logs/compositor.stdout.log \
	2> /tmp/yGreeter/logs/compositor.stderr.log
