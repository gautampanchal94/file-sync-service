#!/usr/bin/env bash
if [ -z "$(which inotifywait)" ]; then
    echo "inotifywait not installed."
    echo "In most distros, it is available in the inotify-tools package."
    exit 1
fi

function execute() {
    rsync -cau /source/file/path /dest/file/path
}

if [ -f /home/cue/.metacbs/config.json]; then
    inotifywait --monitor --format "%e %w%f" \
    --event modify,move,create,delete /source/file/path \
    | while read changed; do
        echo $changed
        execute "$@"
    done
else
    touch /source/file/path;
    sudo rsync -av /dest/file/path /source/file/path;
    inotifywait --monitor --format "%e %w%f" \
    --event modify,move,create,delete /source/file/path \
    | while read changed; do
        echo $changed
        execute "$@"
    done
fi