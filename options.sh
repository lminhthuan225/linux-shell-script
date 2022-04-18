#!/bin/bash

word="abc"

while getopts "h:" option; do
	case $option in
		h) word=$OPTARG
	esac
done

echo "$word"

