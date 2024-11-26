#!/bin/bash
# vim: sw=2 et

set -e

export Color_Reset='\033[0m'
export Green='\033[0;32m'

if [[ "$1" =~ ^(--help|-h)$ ]] || [ ! -n "$1" ]; then
    echo -e "$(cat << EOF
Convert input file from args to mp4 using ffmpeg.

file.mp4 will be renamed to file_orig.mp4.

Requirements:
- ffmpeg
- nproc

Usage: ${Green}$(basename "$0")${Color_Reset} file.mp4 [additional_ffmpeg_args]
EOF
)"
    exit 1
fi

if [ ! -f "$1" ]; then
  echo "ERROR: input file: no such file"
  exit 1
fi
input_file="$1"
shift

input_file_ext="${input_file##*.}"
if [[ "$input_file_ext" = "mp4" ]]; then
  output_file="$input_file"
  input_file="$(echo "$input_file" | cut -f 1 -d '.')_orig.mp4"
  mv -v "$output_file" "$input_file"
else
  output_file="$(echo "$input_file" | cut -f 1 -d '.').mp4"
fi

echo "Calculate thread count..."
threads=$(nproc)
# Reduce threads by 4 if there are more then 7 cores or else set threads to half of core count
if [ "$threads" -ge 8 ]; then export threads=$(( threads - 4 )); else export threads=$(( threads / 2 )); fi
# Set threads to 1 if calculated value is less then 1
if [ "$threads" -lt 1 ]; then export threads=1; fi
echo "Thread count: $threads"

set -x
nice -n 19 ffmpeg -i "$input_file" -preset veryslow "$@" "$output_file"
