#! /bin/bash

if [[ "$EUID" = 0 ]]; then
	echo "Never use sudo or a root account for trivial stuff, you're inviting disasters and viruses in..."
	echo "Program is quitting and didn't execute anything..."
	exit
fi

while [[ $# -ne 0 ]]; do
	#Get filename extension
	current_file="$(basename ${1})"
	current_path="$(dirname ${1})"
	received_extension="${current_file##*.}"
	current_file_with_removed_extension="${current_file%.*}"

	tested_extension="$(file ${current_path}/${current_file})"
	case "$tested_extension" in
		"${1}: JPEG image data"*"")
		 calculated_extension="jpg"
		 ;;
		"${1}: PNG image data"*"")
		 calculated_extension="png"
		 ;;
		"${1}: GIF image data"*"")
		 calculated_extension="gif"
		 ;;
		"${1}: ISO Media, MP4"*"")
		 calculated_extension="mp4"
		 ;;
		"${1}: RIFF (little-endian) data, AVI"*"")
		 calculated_extension="avi"
		 ;;
		"${1}: PDF document, version"*"")
		 calculated_extension="pdf"
		 ;;
		""*"")
		 calculated_extension="unknown"
		 ;;
	esac
	echo "$calculated_extension"
	shift
done
