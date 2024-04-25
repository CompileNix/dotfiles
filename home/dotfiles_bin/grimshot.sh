#!/bin/bash
# vim: sw=4 et
set -e

Color_Reset='\033[0m'
Green='\033[0;32m'
Underline_Yellow='\033[4;33m'
Underline_Purple='\033[4;35m'

if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ] || [ ! -n "$2" ] || [ ! -n "$3" ]; then
    echo -e "$(cat << EOF
Function to take a screenshot using grimshot and save it in the given
directory.

Requirements:
- grimshot

Usage: ${Green}$(basename "$0")${Color_Reset} ${Underline_Yellow}target_directory${Color_Reset} ${Underline_Purple}grimshot_args${Color_Reset}

${Underline_Yellow}target_directory${Color_Reset}    Path to the directory where the screenshot sould be saved
${Underline_Purple}grimshot_args${Color_Reset}       Your grimshot args, see more with "${Green}grimshot${Color_Reset} --help"

Example: ${Green}$(basename "$0")${Color_Reset} ${Underline_Yellow}"$HOME/Pictures/Screenshots"${Color_Reset} ${Underline_Purple}save area${Color_Reset}
EOF
)"
    exit 1
fi

path="$1"; shift
args="$*"

path="${path}/Screenshot from $(date +"%Y-%m-%d.%H%M").png"
grimshot $args "$path"

