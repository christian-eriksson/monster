#!/bin/sh
# Extends the the disk script from:
# https://github.com/vivien/i3blocks-contrib/tree/master/disk

DIR="${DIR:-$BLOCK_INSTANCE}"
DIR="${DIR:-$HOME}"
ALERT_LOW="${ALERT_LOW:-15}"
CRITICAL_LOW="${CRITICAL_LOW:-5}"

LOCAL_FLAG="-l"
if [ "$1" = "-n" ] || [ "$2" = "-n" ]; then
    LOCAL_FLAG=""
fi

df -h -P $LOCAL_FLAG "${DIR}" | awk \
  -v label="${LABEL}" \
  -v alert_low=$ALERT_LOW \
  -v critical_low=$CRITICAL_LOW \
  -v font="${FONT}" \
  -v alert_color="${WARNING_COLOR}" \
  -v critical_color="${CRITICAL_COLOR}" \
  -v markup="${markup}" '
/\/.*/ {
  full_text=$4

  if (label != "") {
    full_text=" " full_text
  }

  if (markup == "pango" && font != "") {
    full_text="<span font_family=\"" font "\">" full_text "</span>"
  }

  full_text=label full_text
	print full_text

  short_text=full_text
	print short_text

	use=$5

	# no need to continue parsing
	exit 0
}

END {
	gsub(/%$/,"",use)
	if (100 - use < critical_low) {
    print critical_color
	} else if (100 - use < alert_low) {
		print alert_color
  }
}
'
