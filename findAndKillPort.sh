#!/bin/bash


PORT_NUMBER="$1"
PORT_PID=$(lsof -i -P -n | grep $PORT_NUMBER | egrep "[0-9]" | uniq)
[[ -z $PORT_PID ]] && echo "No service running on this port" ||  (
sudo kill $PORT_PID)
echo $PORT_PID
