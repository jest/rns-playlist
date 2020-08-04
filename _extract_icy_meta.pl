use v5.20;

use warnings;
use strict;

use POSIX qw(strftime);

binmode(STDIN);
binmode(STDOUT);
$| = 1;

while (my $cnr = read STDIN, my $bytes, 16000) {
	exit if $cnr != 16000;
	exit unless read STDIN, my $len, 1;
	$len = 16 * ord($len);
	if ($len > 0) {
		exit unless read(STDIN, my $meta, $len) == $len;
		my $ts = strftime "%Y-%m-%d %H:%M:%S", localtime;
		say $ts, ' ', $meta;
	}
}
