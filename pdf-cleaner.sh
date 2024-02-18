#! /bin/bash

if [[ "$EUID" = 0 ]]; then
        echo "Never use sudo or a root account for trivial stuff, you're inviting disasters and viruses in..."
        echo "Program is quitting and didn't execute anything..."
        exit
fi

tmp_img_proc_dir="/tmp/temp-imgs-pdf-conversion"
mkdir "${tmp_img_proc_dir}"
running_path_of_script="$(dirname $0)"

while [[ $# -ne 0 ]]; do
	#Somewhat on the fence over this because this might be able to run commands if something is injected under var running_path, the only thing stopping that from happening is the curly braces around it
	current_index_of_shell_parameter_expansion="$(${running_path_of_script}/file-name-cleaner.sh ${1} | head -1)"

	#Safer alternative than ommitting path part via expression
	current_file="$(basename ${current_index_of_shell_parameter_expansion})"

	echo "Converting PDF file: $current_file into multiple PNG files..."

	#PNG files have less complicated metadata fields so less attack surface
	pdftoppm "${current_index_of_shell_parameter_expansion}" "${tmp_img_proc_dir}/out-${current_file}" -png

	echo "Cleaning individual PNG files..."

	"${running_path_of_script}/ffmpeg-file-cleaner.sh" "${tmp_img_proc_dir}/out-${current_file}"*".png"
	img2pdf "${tmp_img_proc_dir}/"*".png" -o "${tmp_img_proc_dir}/converted-pdf-out.pdf"
	mv "${tmp_img_proc_dir}/converted-pdf-out.pdf" "${current_index_of_shell_parameter_expansion}"

	#img2pdf names generated images always the same.
	#So to avoid all pdfs parsed in one sitting from using the same images, remove the old ones
	rm "${tmp_img_proc_dir}/"*".png"
	shift
done

rm -rf "${tmp_img_proc_dir}"
