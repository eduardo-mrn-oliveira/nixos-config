#!/usr/bin/env bash

if [ -f /etc/profile ]; then . /etc/profile; fi
if [ -f "$HOME/.profile" ]; then . "$HOME/.profile"; fi

reset

exec "$@"
