#!/bin/bash
echo "Hello world"

find_port() {
	PORT_NUMBER="$1"
	[[ -z $PORT_NUMBER ]] && echo "port is required" || 
	(
		SERVICE_NAME=$(lsof -i -P -n | grep "$PORT_NUMBER" | awk '{print $1}' | uniq)
		if [[ -z $SERVICE_NAME ]]; then 
			echo "No service running on that port"
		else 
			echo $SERVICE_NAME
		fi
	)
}

find_all_sh_file_in_folder() {
	FOLDER_PATH="$1"
	[[ -z $FOLDER_PATH ]] && echo "folder path is required" ||
	(
		ALL_FILE=$(find "$FOLDER_PATH" -type f -name "*.sh" | awk -F "/" '/^\// {print $NF}')
		echo $ALL_FILE
	)
}

find_and_replace_string() {
	REPLACED_STRING="$1"
	[[ -z $REPLACED_STRING ]] && echo "replaced string is required" ||
	(
		HOME="/home/$USER"
		ALL_FILE=$(sed 's/\@/'"$REPLACED_STRING"'/g' $HOME/test.txt)
		echo $ALL_FILE
	)
}

find_total_disk() {
	LINE_NUMBER=$(df -h |awk '{print $NF}' | egrep -n '^\/$' | awk -F ":" '{print $1}') #mounted on /
	echo "Total disk: " $(df -h | sed -n "4p" | awk '{print $2}')
	echo "% disk usage: " $(df -h | sed -n "4p" | awk '{print $5}')
}

PORT_NUMBER=""
FOLDER_PATH=""
REPLACED_STRING=""

while true
do
	echo "Choose your needs:"
	echo "1. Find all the file with extension .sh in a folder"
	echo "2. Find and replace a specific string(with special character)"
	echo "3. Find service running on what port"
	echo "4. View CPU_INFO(cpu, mem, disk)"

	read -n 1 -p "Input selection: " userChoice

	case $userChoice in
	1)
		while [[ -z $FOLDER_PATH ]]
		do
			echo "Enter folder path: "
			read FOLDER_PATH || exit 
			find_all_sh_file_in_folder $FOLDER_PATH
		done
		FOLDER_PATH=""
	;;
	2)
		while [[ -z $REPLACED_STRING ]]
		do
			echo "Enter replaced string: "
			read -t 10 REPLACED_STRING || exit 
			find_and_replace_string $REPLACED_STRING
		done
		REPLACED_STRING=""
	;; 
	3) 
		while [[ -z $PORT_NUMBER ]]
		do
			echo "Enter port: "
			read -t 10 PORT_NUMBER || exit 
			find_port $PORT_NUMBER
		done
		PORT_NUMBER=""
	;;
	4)
		echo ""
		echo "Total CPU: " $(lscpu | egrep -n "CPU\(s\):" | sed -n '1p' | awk '{print $NF}')
		echo "% CPU usage: " $(echo "100 $(mpstat | awk '{print $NF}' | sed -n '4p')" | awk '{print $1 - $2}')
		echo "Total Memory: " $(free -m | sed -n '2p' | awk '{print $2}') 
		echo "% Mem usage: " $(free -m | sed -n '2p' | awk '{print $3 / $2 * 100}')"%"
		find_total_disk
	;;	
	esac
done

echo "Something change here"






