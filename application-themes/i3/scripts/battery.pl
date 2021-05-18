#!/usr/bin/perl -CSDA
# Adapts the the battery script from:
# https://github.com/vivien/i3blocks-contrib/tree/master/battery

use strict;
use warnings;
use utf8;

my $battery_empty="";
my $battery_10="";
my $battery_20="";
my $battery_30="";
my $battery_40="";
my $battery_50="";
my $battery_60="";
my $battery_70="";
my $battery_80="";
my $battery_90="";
my $battery_100="";
my $charging_20="";
my $charging_30="";
my $charging_40="";
my $charging_60="";
my $charging_80="";
my $charging_90="";
my $charging_100="";
my $acpi;
my $status;
my $percent;
my $ac_adapt;
my $full_text;
my $short_text;
my $bat_number = $ENV{BAT_NUMBER} || 0;
my $label = $ENV{LABEL} || "";
my $markup = $ENV{markup};
my $font = $ENV{FONT};
my $color_notice = $ENV{WARNING_COLOR} // "#EDFF00";
my $color_warn = $ENV{WARNING_COLOR} // "#FFFC00";
my $color_crit = $ENV{CRITICAL_COLOR} // "#FF0000";
my $color;

# read the first line of the "acpi" command output
open (ACPI, "acpi -b 2>/dev/null| grep 'Battery $bat_number' |") or die;
$acpi = <ACPI>;
close(ACPI);

# fail on unexpected output
if (not defined($acpi)) {
    exit(0);
}
elsif ($acpi !~ /: ([\w\s]+), (\d+)%/) {
	die "$acpi\n";
}

$status = $1;
$percent = $2;

$full_text = "${percent}%";

if ($acpi =~ /(\d\d:\d\d):/) {
	$full_text .= " ($1)";
}

if ("${markup}" eq "pango" && length "${font}") {
  $full_text="<span font_family=\"${font}\"> ${full_text}</span>";
}

$short_text=$full_text;

sub get_discharge_label {
  my ($percent) = @_;
  my $label;
  if ($percent < 5) {
    $label=$battery_empty;
  } elsif ($percent < 15) {
    $label=$battery_10;
  } elsif ($percent < 25) {
    $label=$battery_20;
  } elsif ($percent < 35) {
    $label=$battery_30;
  } elsif ($percent < 45) {
    $label=$battery_40;
  } elsif ($percent < 55) {
    $label=$battery_50;
  } elsif ($percent < 65) {
    $label=$battery_60;
  } elsif ($percent < 75) {
    $label=$battery_70;
  } elsif ($percent < 85) {
    $label=$battery_80;
  } elsif ($percent < 95) {
    $label=$battery_90;
  } else {
    $label=$battery_100;
  }
  return $label;
}

sub get_charge_label {
  my ($percent) = @_;
  my $label;
  if ($percent < 20) {
    $label=$charging_20;
  } elsif ($percent < 30) {
    $label=$charging_30;
  } elsif ($percent < 40) {
    $label=$charging_40;
  } elsif ($percent < 60) {
    $label=$charging_60;
  } elsif ($percent < 80) {
    $label=$charging_80;
  } elsif ($percent < 90) {
    $label=$charging_90;
  } else {
    $label=$charging_100
  }
  return $label;
}

if (!length $label) {
  if ($status eq 'Discharging') {
    $label=get_discharge_label($percent);
  } elsif ($status eq 'Charging') {
    $label=get_charge_label($percent);
  } elsif ($status eq 'Unknown') {
    open (AC_ADAPTER, "acpi -a |") or die;
    $ac_adapt = <AC_ADAPTER>;
    close(AC_ADAPTER);

    if ($ac_adapt =~ /: ([\w-]+)/) {
      $ac_adapt = $1;

      if ($ac_adapt eq 'on-line') {
        $label=get_charge_label($percent);
      } elsif ($ac_adapt eq 'off-line') {
        $label=get_discharge_label($percent);
      }
    }
  }
}

$full_text="${label}${full_text}";

$short_text = $full_text;

# print text
print "$full_text\n";
print "$short_text\n";

# consider color on discharge
if ($status eq 'Discharging') {
	if ($percent < 10) {
		print "${color_crit}\n";
	} elsif ($percent < 20) {
		print "${color_warn}\n";
	} elsif ($percent < 40) {
		print "${color_notice}\n";
	}
}

exit(0);
