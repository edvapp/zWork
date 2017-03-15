#!/bin/bash

function killInotifyWait()
{
	# check, if an inotifywait process is running and kill it
	LOST_INOTIFY=$(ps ef | grep "inotifywait -e close_write $DIRECTORY_TO_MONITOR" | grep -v grep |  awk '{ print $1 }')
	if [ ! "$LOST_INOTIFY" = "" ];
	then
		kill $LOST_INOTIFY
	fi
}

DIRECTORY_TO_MONITOR="$HOME/pdf-spooler"
DIRECTORY_TO_MONITOR_FOR_COLOR="$DIRECTORY_TO_MONITOR/color"

# create spooler directory, if it does not exist
if [ ! -d $DIRECTORY_TO_MONITOR ];
then
	mkdir -p $DIRECTORY_TO_MONITOR_FOR_COLOR
fi

# check, if Color-Printer available
#COLOR_PRINTER_NAME=Printer-Color
COLOR_PRINTER_NAME=
#lpstat -v 

# check for a lost inotifywait process
killInotifyWait

# start monitoring for $DIRECTORY_TO_MONITOR in background (see &)
# and sent files to standard printer
inotifywait -e close_write $DIRECTORY_TO_MONITOR -m -r --format "%w%f" | \
while read PATH_AND_FILE; 
do 
	# if $DIRECTORY_TO_MONITOR_FOR_COLOR not in filepath, filepath stays unchanged,
	# and file must exist in $DIRECTORY_TO_MONITOR
	if [ "${PATH_AND_FILE#"$DIRECTORY_TO_MONITOR_FOR_COLOR"}" = "$PATH_AND_FILE" ];
	then
		echo lp "$PATH_AND_FILE" 
	else 
		if [ ! "$COLOR_PRINTER_NAME" = "" ];
		then
			echo "lp -p $COLOR_PRINTER_NAME" "$PATH_AND_FILE" 
		fi
	fi
	echo rm "$PATH_AND_FILE"; 
done &

echo "start VM"
read x

# kill running inotify
killInotifyWait

# remove spooler directory
rm -r $DIRECTORY_TO_MONITOR
