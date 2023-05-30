#!/usr/bin/env bash
# check if inotifywait is installed
if [ -z "$(which inotifywait)" ]; then
    echo "inotifywait not installed."
    echo "In most distros, it is available in the inotify-tools package."
    exit 1
fi

# check if jq is installed
if [ -z "$(which jq)" ];then
	echo "jq not installed."
    echo "In most distros, it is available as package."
	exit 1
fi

# file location
SOURCE=/file/path/to/source
DEST=/file/path/to/dest
LOGS=/var/log/<filename>.log

# function to execute after file is modify
function execute() {
    # check if JSON is valid -> Change base on need
    if jq -e . >/dev/null 2>&1 <<< cat $SOURCE; then
        echo "$(date) $SOURCE modified." >> $LOGS   # added logs when file was modified
        rsync -avu $SOURCE $DEST >> $LOGS   # incremental update to file
        echo "----------" >> $LOGS  # seprator each time function called
    fi
}

# check fo if file exists
if [ -f $SOURCE ]; then
    # init inotifywait for the file
    inotifywait --monitor --format "%e %w%f" \
    --event modify,move,create $SOURCE \
    | while read changed; do
        execute "$@"
    done
else
    # if file doesn't exits create file
    touch $SOURCE;
    # init inotifywait for the file
    inotifywait --monitor --format "%e %w%f" \
    --event modify,move,create $SOURCE \
    | while read changed; do
        execute "$@"
    done
fi
