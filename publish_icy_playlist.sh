#!/bin/bash

set -o errexit
set -o nounset

retry () {
	local tries=$1
	shift
	local interval=$1
	shift

	local try=1
	until "$@"; do
		local err=$?
		printf "Try %d of %d, exit code %s." $try $tries $err >&2
		if [ $try -ge $tries ]; then
			echo " Giving up." >&2
			return $err
		fi
		printf " Waiting %d seconds before retry.\n" $interval >&2
		sleep $interval
		interval=$(( interval * 2 ))
	done
}

while true; do
	inotifywait icy/stream*.txt icy/.wakeup

	date
	echo Producing playlists
	cat icy/stream*.txt | perl -C make_playlist_icy.pl >playlist.icy

	echo Publishing
	date >surge/out/index.txt
	echo >> surge/out/index.txt
	cat playlist-pre-icy >> surge/out/index.txt
	cat playlist.icy >> surge/out/index.txt
	
	cd surge
	retry 8 5 npx surge out/
	cd ..

	date
	echo Done
done
