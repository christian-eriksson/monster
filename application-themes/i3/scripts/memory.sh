#!/bin/sh
# Extends the the memory script from:
# https://github.com/vivien/i3blocks-contrib/tree/master/memory

TYPE="${BLOCK_INSTANCE:-mem}"
FORMAT="${FORMAT:-used}"

awk \
  -v type=$TYPE \
  -v format=$FORMAT \
  -v notice_color=$NOTICE_COLOR \
  -v warning_color=$WARNING_COLOR \
  -v critical_color=$CRITICAL_COLOR \
  -v font="${FONT}" \
  -v markup="${markup}" \
  -v label=$label '
/^MemTotal:/ {
	mem_total=$2
}
/^MemFree:/ {
	mem_free=$2
}
/^Buffers:/ {
	mem_free+=$2
}
/^Cached:/ {
	mem_free+=$2
}
/^SwapTotal:/ {
	swap_total=$2
}
/^SwapFree:/ {
	swap_free=$2
}
END {
	if (type == "swap") {
		free=swap_free/1024/1024
		used=(swap_total-swap_free)/1024/1024
		total=swap_total/1024/1024
	} else {
		free=mem_free/1024/1024
		used=(mem_total-mem_free)/1024/1024
		total=mem_total/1024/1024
	}

	percentage_used=0
	if (total > 0) {
		percentage_used=used/total*100
	}

  if (format != "full") {
    full_text="%.1fG"
  } else {
    full_text="%.1fG/%.1fG (%.f%%)"
  }

  short_text="%.1fG"

  if (label != "") {
    full_text=" " full_text
    short_text=" " short_text
  }

  if (markup == "pango" && font != "") {
    full_text="<span font_family=\"" font "\">" full_text "</span>"
    short_text="<span font_family=\"" font "\">" short_text "</span>"
  }

  short_text=short_text

	# full text
  if (format == "used") {
    printf(full_text "\n", used)
  } else if (format == "full") {
    printf(full_text "\n", used, total, percentage_used)
  } else if (format == "free") {
    printf(full_text "\n", free)
  } else if (format == "percentage") {
    printf(full_text "\n", percentage_used)
  }

	# short text
	printf(short_text "\n", percentage_used)

	# color
	if (percentage_used > 95) {
		print(critical_color)
	} else if (percentage_used > 85) {
		print(warning_color)
	} else if (percentage_used > 75) {
		print(notice_color)
	}
}
' /proc/meminfo