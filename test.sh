#!/bin/bash -e

ALL_ARGS=$@

for arg in $ALL_ARGS; do
	shift
	case $arg in
		"--server-url") set -- "$@" "-u" ;;
		"--node-name") set -- "$@" "-n" ;;
		"--"*) echo "usage $arg" command not found
			exit 1;
		;;
		*) set -- $@ $arg;;
	esac
done

# Default behavior
rest=false; ws=false

# Parse short options
OPTIND=1
while getopts "un" opt
do
  case "$opt" in
	u) echo $OPTARG
	
  esac
done

echo $@
