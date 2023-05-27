#!/usr/bin/env bash

if [ -z "$(which inotifywait)" ]; then
    echo "inotifywait not installed."
    echo "In most distros, it is available in the inotify-tools package."
    exit 1
fi

# counter=0;

function execute() {
    # counter=$((counter+1))
    # echo "Detected change n. $counter"
    # eval "$@"
    rsync -cau /home/cue/.metacbs/config.json /var/lib/homebridge/config.json
}

inotifywait --monitor --format "%e %w%f" \
--event modify,move,create,delete /home/cue/.metacbs/config.json \
| while read changed; do
    echo $changed
    execute "$@"
done
