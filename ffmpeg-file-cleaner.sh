#! /bin/bash

mkdir "/tmp/ffmpeg-file-cleaner-temp-proc-files"
while [[ $# -ne 0 ]]; do
	current_index_of_shell_parameter_expansion=$1

	#Strip given filename of its path
	current_file=${current_index_of_shell_parameter_expansion##*/}

	#Destroy all metadata by keeping the data itself and recreating the data headers around them
	ffmpeg -i "$1" -c copy "/tmp/ffmpeg-file-cleaner-temp-proc-files/clean-$current_file"
	cp "/tmp/ffmpeg-file-cleaner-temp-proc-files/clean-$current_file" "$1"
	shift
done
rm -rf "/tmp/ffmpeg-file-cleaner-temp-proc-files"
