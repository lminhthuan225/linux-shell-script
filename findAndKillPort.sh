#!/bin/bash


PORT_NUMBER="$1"
PORT_PID=$(lsof -i -P -n | grep $PORT_NUMBER | egrep "[0-9]" | uniq)

echo $PORT_PID
