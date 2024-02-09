#! /bin/bash

mkdir "/tmp/temp-imgs-pdf-conversion"
while [[ $# -ne 0 ]]; do
	current_index_of_shell_parameter_expansion=$1

        #Strip given filename of its path
        current_file=${current_index_of_shell_parameter_expansion##*/}

	echo "Converting PDF file: $current_file into multiple PNG files..."

	#PNG files have less complicated metadata fields so less attack surface
	pdftoppm "$1" "/tmp/temp-imgs-pdf-conversion/out-$current_file" -png

	echo "Cleaning individual PNG files..."

	./ffmpeg-file-cleaner.sh "/tmp/temp-imgs-pdf-conversion/out-$current_file"*".png"
	img2pdf "/tmp/temp-imgs-pdf-conversion/"*".png" -o "/tmp/temp-imgs-pdf-conversion/converted-pdf-out.pdf"
	cp "/tmp/temp-imgs-pdf-conversion/converted-pdf-out.pdf" "$1"
	shift
done

rm -rf "/tmp/temp-imgs-pdf-conversion"
