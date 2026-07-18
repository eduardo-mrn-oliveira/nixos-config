#!/usr/bin/env bash

printf "\033[?25l"

stty -echo

clear

if [ -f /etc/profile ]; then . /etc/profile; fi
if [ -f "$HOME/.profile" ]; then . "$HOME/.profile"; fi

exec "$@" \
	> /tmp/yGreeter/logs/sessions/$(whoami).stdout.log \
	2> /tmp/yGreeter/logs/sessions/$(whoami).stderr.log
