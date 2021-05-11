#!/usr/bin/env perl
# Extends the the cpu_usage script from:
# https://github.com/vivien/i3blocks-contrib/tree/master/cpu_usage

use strict;
use warnings;
use utf8;
use Getopt::Long;

# default values
my $t_warn = $ENV{T_WARN} // 50;
my $t_crit = $ENV{T_CRIT} // 80;
my $cpu_usage = -1;
my $decimals = $ENV{DECIMALS} // 2;
my $label = $ENV{label} // "";
my $color_t_warn = $ENV{WARNING_COLOR} // "#FFFC00";
my $color_t_crit = $ENV{CRITICAL_COLOR} // "#FF0000";
my $markup = $ENV{markup};
my $font = $ENV{FONT};

sub help {
    print "Usage: cpu_usage [-w <warning>] [-c <critical>] [-d <decimals>] [-a <hex color>] [-k <hex color>]\n";
    print "-w <percent>: warning threshold to become yellow\n";
    print "-c <percent>: critical threshold to become red\n";
    print "-d <decimals>:  Use <decimals> decimals for percentage (default is $decimals) \n";
    print "-a <hex color>:  Use <hex color> to change default warning color (default is $color_t_warn) \n";
    print "-k <hex color>:  Use <hex color> to change default critical color (default is $color_t_crit) \n";
    exit 0;
}

GetOptions("help|h" => \&help,
           "w=i"    => \$t_warn,
           "c=i"    => \$t_crit,
           "d=i"    => \$decimals,
           "a=i"    => \$color_t_warn,
           "k=i"    => \$color_t_crit,
);

my $full_text="%.${decimals}f%%";

if (length $label) {
  $full_text=" ${full_text}";
}


if ("${markup}" eq "pango" && length "${font}") {
  $full_text="<span font_family=\"${font}\">${full_text}</span>";
}

my $short_text=$full_text;

# Get CPU usage
$ENV{LC_ALL}="en_US"; # if mpstat is not run under en_US locale, things may break, so make sure it is
open (MPSTAT, 'mpstat 1 1 |') or die;
while (<MPSTAT>) {
    if (/^.*\s+(\d+\.\d+)[\s\x00]?$/) {
        $cpu_usage = 100 - $1; # 100% - %idle
        last;
    }
}
close(MPSTAT);

$cpu_usage eq -1 and die 'Can\'t find CPU information';

# Print short_text, full_text
printf "${full_text}\n", $cpu_usage;
printf "${short_text}\n", $cpu_usage;

# Print color, if needed
if ($cpu_usage >= $t_crit) {
    print "${color_t_crit}\n";
} elsif ($cpu_usage >= $t_warn) {
    print "${color_t_warn}\n";
}

exit 0;
