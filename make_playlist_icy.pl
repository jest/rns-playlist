use v5.20;
use strict;
use warnings;

use utf8;

my $last_text;
my $last_dt = '';
my $last_hr = '';

my @blacklist = (
	qr/^\s*-\s*$/,
	qr/^Radio Nowy .+wiat - Pion i poziom!$/
);

while (<STDIN>) {
	chomp;
	next unless /^(\d{4})-(\d{2})-(\d{2})(?: |T)(\d+):(\d+):(\d+)(?:\+0[12]:00)?\s*(.*)$/;
	my ($dt, $hr, $min, $meta_txt) = ("$1-$2-$3", $4, $5, $7);
	# yes, StreamTitle='someone's unquoted tilde'; is pretty common... :(
	next unless $meta_txt =~ /StreamTitle='(.*?)';/;
	my $txt = $1;
	
	if ($last_dt ne $dt || !defined($last_text) || $txt ne $last_text) {
		unless (grep { $txt =~ $_ } @blacklist) {
			if ($dt ne $last_dt || $hr ne $last_hr) {
				say '';
			}
			printf "%10s %02d:%02d %s\n",
				($dt eq $last_dt) ? '' : $dt,
				$hr, $min,
				$txt;
			$last_hr = $hr;
			$last_text = $txt;
			$last_dt = $dt;
		}
	}
}

