#!/usr/bin/perl
# displays the 256 colors specified in tmux's "colourNN" way.
# June, 1st 2011 by Yasunori Taniike (@ytaniike).

use strict;
use warnings;

my $prefix_bl = "\x1b[38;5;0;48;5;";
my $prefix_wl = "\x1b[38;5;15;48;5;";
my $suffix = "\x1b[0m";

sub _color_part {
    my $color = shift;
    return sprintf("m C%03d ", $color);
}

# for colors0 to colors7 (also known as "system colors": black, red, green, yellow,
#  blue, magenta, cyan, white)
print "System colors: 8 colors x 2 rows:\n";
foreach my $color (0..7) {
    print "$prefix_wl$color" . _color_part($color);
}
print "$suffix\n";
foreach my $color (8..15) {
    print "$prefix_bl$color" . _color_part($color);
}
print "$suffix\n\n";

print "colour16 to colour231:\n";
my $index_offset = 15;
my $prefix = $prefix_wl;
foreach my $color (16..231) {
    $prefix = $prefix_bl if ($color > 123);
    print "$prefix$color" . _color_part($color);
    print "$suffix\n"
        if (($color - $index_offset) % (2*6) == 0); 
}
print "\n";

# grayscale
print "colour232 to colour255: Gray scale\n";
$prefix = $prefix_wl;
foreach my $color (232..255) {
    $prefix = $prefix_bl if ($color > 243);
    print "$prefix$color" . _color_part($color);
    print "$suffix\n"
        if (($color - $index_offset) % (2*6) == 0); 
}
exit (0);
