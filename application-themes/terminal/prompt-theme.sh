#!/bin/sh

__m_section_delimiter=""
__m_section_divider_symbol=""

# Using \001 and \002 instead of \[ and \] since the __m_reset_style will be used in command substitution
# https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Bash_escape_sequences
# https://superuser.com/questions/301353/escape-non-printing-characters-in-a-function-for-a-bash-prompt/301355#301355
__m_reset_style="\001\e[0m\002"
__m_clear_line="\033[K"

__m_venv_label_symbol=""
__m_venv_foreground_color="177;29;118"
__m_venv_background_color="51;51;51"

__m_user_label_symbol=""
__m_user_foreground_color="5;138;190"
__m_user_background_color="60;60;60"

__m_root_label_symbol=""
__m_root_foreground_color="196;36;132"
__m_root_background_color="${__m_user_background_color}"

__m_path_label_symbol=""
__m_path_foreground_color="105;172;197"
__m_path_background_color="85;85;85"

__m_git_label_symbol=""
__m_git_foreground_color="2;66;92"
__m_git_background_color="170;170;170"
__m_git_branch_symbol=""
__m_git_tag_symbol="笠"
__m_git_commit_symbol=""
__m_git_synced_symbol=""
__m_git_not_synced_symbol=""
__m_git_diverged_symbol=""
__m_git_ahead_symbol=""
__m_git_behind_symbol=""
__m_git_staged_symbol=""
__m_git_unstaged_symbol=""
__m_git_untracked_symbol=""

# __m_input_label_symbol=""
# __m_input_label_symbol=""
# __m_input_label_symbol=""
# __m_input_label_symbol=""
# __m_input_label_symbol=""
__m_input_label_symbol=""
__m_input_foreground_color="51;51;51"
__m_input_background_color="105;172;197"

__m_root_input_label_symbol=""
__m_root_input_foreground_color="51;51;51"
__m_root_input_background_color="221;4;138"

__m_input_start_symbol=""
__m_secondary_input_start_symbol=""

__m_create_color() {
  __m_fcolor="$1"
  __m_bcolor="$2"
  __m_color="\001\e["
  [ -n "${__m_fcolor}" ] && __m_color="${__m_color}1;38;2;${__m_fcolor}"
  if [ -n "${__m_bcolor}" ]; then
    [ -n "${__m_fcolor}" ] && __m_color="${__m_color};"
    __m_color="${__m_color}48;2;${__m_bcolor}"
  fi
  echo -e "${__m_color}m\002"
}

__m_get_section_end() {
  __m_current_background="$1"
  __m_next_background="$2"
  __m_section_color=$(__m_create_color "${__m_current_background}" "${__m_next_background}")
  echo -e "${__m_section_color}${__m_section_delimiter}${__m_reset_style}"
}

__m_get_label() {
  __m_foreground_color="$1"
  __m_background_color="$2"
  __m_label_symbol="$3"
  __m_label_start_color=$(__m_create_color "${__m_foreground_color}" "${__m_background_color}")
  __m_label_end_color=$(__m_create_color "${__m_background_color}" "${__m_foreground_color}")
  echo -e "${__m_label_start_color} ${__m_label_symbol} ${__m_label_end_color}${__m_section_delimiter}${__m_reset_style}"
}

__m_is_in_venv() {
  [ -n "$VIRTUAL_ENV" ] && return
  false
}

__m_get_venv_section() {
  __m_next_foreground_color="$1"
  if __m_is_in_venv; then
    __m_venv_start_color=$(__m_create_color "${__m_venv_foreground_color}" "${__m_venv_background_color}")
    __m_section_end="$(__m_get_section_end "$__m_venv_background_color" "$__m_next_foreground_color")"
    __m_venv_label="$(__m_get_label "$__m_venv_background_color" "$__m_venv_foreground_color" "$__m_venv_label_symbol")"
    echo -e "${__m_venv_label}${__m_venv_start_color} ($(basename $VIRTUAL_ENV)) ${__m_section_end}${__m_reset_style}"
  else
    echo ""
  fi
}

__m_is_git_path() {
  __m_git_executable=$(which git 2>/dev/null)
  if [ -x "$__m_git_executable" ]; then
    $__m_git_executable status &>/dev/null
    __m_git_status_return=$?
  fi
  [ -x "$__m_git_executable" ] && [ "${__m_git_status_return}" == "0" ] && return
  false
}

__m_get_path_end() {
  if __m_is_git_path; then
    __m_section_end="$(__m_get_section_end "$__m_path_background_color" "$__m_git_foreground_color")"
  else
    __m_section_end="$(__m_get_section_end "$__m_path_background_color")"
  fi
  echo -e "${__m_reset_style}${__m_section_end}"
}

__m__get_git_head_location() {
  __m_git_branch="$(git symbolic-ref -q --short HEAD 2>/dev/null)"
  __m_git_tag="$(git describe --tags --exact-match 2>/dev/null)"
  __m_git_commit_sha="$(git rev-parse --short HEAD 2>/dev/null)"

  if [ -n "${__m_git_branch}" ]; then
    echo "${__m_git_branch_symbol} ${__m_git_branch}"
  elif [ -n "$__m_git_tag" ]; then
    echo "${__m_git_tag_symbol}${__m_git_tag}"
  else
    echo "${__m_git_commit_symbol} ${__m_git_commit_sha}"
  fi
}

__m_get_git_section() {
  if __m_is_git_path; then
    __m_git_start_color=$(__m_create_color "${__m_git_foreground_color}" "${__m_git_background_color}")
    __m_git_end="$(__m_get_section_end "$__m_git_background_color")"

    __m_git_status="$(git status)"

    [ -n "$(echo "${__m_git_status}" | grep "ahead of .* commits\\?\\.$" -o | grep "[0-9]\\+" -o)" ] && __m_git_ahead=" ${__m_git_ahead_symbol}"
    [ -n "$(echo "${__m_git_status}" | grep "behind .* commits\\?,.*$" -o | grep "[0-9]\\+" -o)" ] && __m_git_behind=" ${__m_git_behind_symbol}"
    [ -n "$(echo "${__m_git_status}" | grep "Your branch .* have diverged,$" -o)" ] && __m_git_diverged=" ${__m_git_diverged_symbol}"

    __m_git_synced="${__m_section_divider_symbol} ${__m_git_not_synced_symbol}"
    [ -z "${__m_git_ahead}" ] && [ -z "${__m_git_behind}" ] && [ -z "${__m_git_diverged}" ] && __m_git_synced="${__m_section_divider_symbol} ${__m_git_synced_symbol}"

    __m_git_sync_status_symbols="${__m_git_synced}${__m_git_ahead}${__m_git_behind}${__m_git_diverged}"

    __m_git_changed_unchanged="$(echo "${__m_git_status}" | grep "^nothing to commit, working tree clean$")"

    if [ -z "${__m_git_changed_unchanged}" ]; then
      [ -n "$(echo "${__m_git_status}" | grep "^Changes to be committed:$")" ] && __m_git_staged=" ${__m_git_staged_symbol}"
      [ -n "$(echo "${__m_git_status}" | grep "^Changes not staged for commit:$")" ] && __m_git_unstaged=" ${__m_git_unstaged_symbol}"
      [ -n "$(echo "${__m_git_status}" | grep "^Untracked files:$")" ] && __m_git_untracked=" ${__m_git_untracked_symbol}"
      __m_git_change_status_symbols=" ${__m_section_divider_symbol}${__m_git_staged}${__m_git_unstaged}${__m_git_untracked}"
    fi

    __m_git_label="$(__m_get_label "$__m_git_background_color" "$__m_git_foreground_color" "${__m_git_label_symbol} ${__m_git_sync_status_symbols}${__m_git_change_status_symbols}")"
    echo -e "${__m_git_label}${__m_reset_style}${__m_git_start_color} $(__m__get_git_head_location) ${__m_reset_style}${__m_git_end}"
  else
    echo ""
  fi
}

__m_user_start_color=$(__m_create_color "${__m_user_foreground_color}" "${__m_user_background_color}")
__m_user_label="$(__m_get_label "$__m_user_background_color" "$__m_user_foreground_color" "$__m_user_label_symbol")"
__m_user_end="$(__m_get_section_end "$__m_user_background_color" "$__m_path_foreground_color")"
__m_user_section="${__m_user_label}${__m_user_start_color} \u@\h ${__m_user_end}"

__m_root_start_color=$(__m_create_color "${__m_root_foreground_color}" "${__m_root_background_color}")
__m_root_label="$(__m_get_label "$__m_root_background_color" "$__m_root_foreground_color" "$__m_root_label_symbol")"
__m_root_end="$(__m_get_section_end "$__m_root_background_color" "$__m_path_foreground_color")"
__m_root_section="${__m_root_label}${__m_root_start_color} \u@\h ${__m_root_end}"

__m_path_start_color=$(__m_create_color "${__m_path_foreground_color}" "${__m_path_background_color}")
__m_path_label="$(__m_get_label "$__m_path_background_color" "$__m_path_foreground_color" "$__m_path_label_symbol")"
__m_path_section="${__m_path_label}${__m_path_start_color} \w \$(__m_get_path_end)"

__m_input_start_color=$(__m_create_color "${__m_input_foreground_color}" "${__m_input_background_color}")
__m_input_indicator_color=$(__m_create_color ${__m_input_background_color})
__m_input_section="${__m_input_start_color} ${__m_input_label_symbol} ${__m_reset_style}${__m_input_indicator_color}${__m_input_start_symbol}"

__m_root_input_start_color=$(__m_create_color "${__m_root_input_foreground_color}" "${__m_root_input_background_color}")
__m_root_input_indicator_color=$(__m_create_color ${__m_root_input_background_color})
__m_root_input_section="${__m_root_input_start_color} ${__m_root_input_label_symbol} ${__m_reset_style}${__m_root_input_indicator_color}${__m_input_start_symbol}"

export VIRTUAL_ENV_DISABLE_PROMPT=1

__m_user_prompt="\n${TITLEBAR}\
\$(__m_get_venv_section \"$__m_user_foreground_color\")\
${__m_user_section}\
${__m_path_section}\
\$(__m_get_git_section)\
${__m_clear_line}\
\n${__m_input_section}${__m_reset_style} "
__m_user_secondary_prompt="${__m_reset_style}${__m_input_indicator_color}${__m_secondary_input_start_symbol}${__m_reset_style} "

__m_root_prompt="\n${TITLEBAR}\
\$(__m_get_venv_section \"$__m_root_foreground_color\")\
${__m_root_section}\
${__m_path_section}\
\$(__m_get_git_section)\
${__m_clear_line}\
\n${__m_root_input_section}${__m_reset_style} "
__m_root_secondary_prompt="${__m_reset_style}${__m_root_input_indicator_color}${__m_secondary_input_start_symbol}${__m_reset_style} "

case "$(id -u)" in
0)
  export PS1="${__m_root_prompt}"
  export PS2="${__m_root_secondary_prompt}"
  ;;
*)
  export PS1="${__m_user_prompt}"
  export PS2="${__m_user_secondary_prompt}"
  ;;
esac
