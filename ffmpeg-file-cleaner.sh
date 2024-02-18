#! /bin/bash

if [[ "$EUID" = 0 ]]; then
	echo "Never use sudo or a root account for trivial stuff, you're inviting disasters and viruses in..."
	echo "Program is quitting and didn't execute anything..."
	exit
fi

tmp_ffmpeg_proc_dir="/tmp/ffmpeg-file-cleaner-temp-proc-files"
mkdir "${tmp_ffmpeg_proc_dir}"
running_path_of_script="$(dirname $0)"

while [[ $# -ne 0 ]]; do
	#Somewhat on the fence over this because this might be able to run commands if something is injected under var running_path,  the only thing stopping that from happening is the curly braces around it
	current_index_of_shell_parameter_expansion="$(${running_path_of_script}/file-name-cleaner.sh ${1} | head -1)"

	#Safer alternative than ommitting path part via expression
        current_file="$(basename ${current_index_of_shell_parameter_expansion})"
	extension="${current_file##*.}"

	#Destroy all metadata by keeping the data itself and recreating the data headers around them
	#Hide banner and logging except for errors because ffmpeg is way too verbose
	#vframes 1 disables image sequencing, when an input image has multiple layers omit the others and only use the base image
	###---TODO: implement GIFs---Porbably start using case instead of if
	if [[ "${extension}"="png" || "${extension}"="jpg" ]]; then
		ffmpeg -hide_banner -loglevel error -i "${current_index_of_shell_parameter_expansion}" -c copy -vframes 1 "${tmp_ffmpeg_proc_dir}/clean-${current_file}"
	else
		ffmpeg -hide_banner -loglevel error -i "${current_index_of_shell_parameter_expansion}" -c copy "${tmp_ffmpeg_proc_dir}/clean-${current_file}"
	fi
	mv "${tmp_ffmpeg_proc_dir}/clean-${current_file}" "${current_index_of_shell_parameter_expansion}"
	shift
done
rm -rf "${tmp_ffmpeg_proc_dir}"
