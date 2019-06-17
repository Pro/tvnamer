#!/bin/sh

inotifywait -m "$1" -e create -e moved_to -e modify --exclude '/[.@]' --format '%w%f' $INOTIFYWAIT_OPTS | stdbuf -oL uniq | while read -r FILE; do
	# file may yield inode/x-empty for new files
	sleep "$SETTLE_DOWN_TIME"

	# abort if the file has been modified while we were asleep
	if [ `find "$FILE" -type f -newermt "$SETTLE_DOWN_TIME seconds ago" -print -quit` ]; then
		echo "Modified: $FILE"
		continue
	fi

	# Remove first arg
	shift
	echo "Detected file change: $FILE"
	tvnamer ${@} $FILE
done
