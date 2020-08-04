set -o errexit
set -o nounset

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
	(cd surge && npx surge out/)
	date
	echo Done
done
