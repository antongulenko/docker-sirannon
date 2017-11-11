#!/bin/bash

if [ -z "$MRL" ]; then
	if [ -z "$MRL_SERVER" ]; then
		echo "Please set the MRL_SERVER environment variable"
		exit 1
	fi
	test -z "$MRL_PORT" && MRL_PORT="1935"
	test -z "$MRL_PATH" && MRL_PATH="/vod/example.flv"
	test -z "$MRL_PROTO" && MRL_PROTO="rtmp"
	MRL="$MRL_PROTO://$MRL_SERVER:$MRL_PORT$MRL_PATH"
fi

test -z "$LOOP" && LOOP=1
# Check if LOOP is a valid number
test "$LOOP" -eq "$LOOP" &> /dev/null || { echo "Warning: invalid LOOP variable '$LOOP'. Using 1."; LOOP=1; }
test $LOOP -le 0 && INFINITE=true || INFINITE=false

i=1
while $INFINITE || [ $i -le $LOOP ]; do
	if $INFINITE; then
		echo "Running ffmpeg $i in infinite loop..."
	else
		echo "Running ffmpeg $i of $LOOP..."
	fi
	i=$((i+1))
	ffmpeg -i "$MRL" -f null /dev/null -loglevel 23 -stats $@ || break
done
