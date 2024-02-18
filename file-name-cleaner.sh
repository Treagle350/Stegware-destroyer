#! /bin/bash

if [[ "$EUID" = 0 ]]; then
	echo "Never use sudo or a root account for trivial stuff, you're inviting disasters and viruses in..."
	echo "Program is quitting and didn't execute anything..."
	exit
fi

detox_tmp_work_dir="/tmp/super-hacky-way-of-getting-the-output-filenames-from-detox"
mkdir "${detox_tmp_work_dir}"
running_path_of_script="$(dirname $0)"

while [[ $# -ne 0 ]]; do
	#Split given filename of its path
        current_file="$(basename ${1})"
	current_path="$(dirname ${1})"

	#Take the files to a temporary work environment
	mv "${current_path}/${current_file}" "${detox_tmp_work_dir}"

        #Remove all suspicious characters
        detox -r "${detox_tmp_work_dir}"

	#Get new filename
	new_name_of_current_file="$(ls ${detox_tmp_work_dir} | head -1)"

	#Create new filename without mutiple extensions
	#We do not trust files, so we don't use this ==> extension="${new_name_of_current_file##*.}"
	#Instead we use this:
	extension="$(${running_path_of_script}/file-extension-verifier.sh ${detox_tmp_work_dir}/${new_name_of_current_file})"
	new_name_of_current_file_with_removed_extension="${new_name_of_current_file%.*}"
	new_name_of_current_file_with_removed_extension_and_dots="${new_name_of_current_file_with_removed_extension//./}"
	cleaned_name_of_current_file="${new_name_of_current_file_with_removed_extension_and_dots}.${extension}"

	#Stupid way of returning a value in bash with echo
	complete_filename_of_cleaned_file="${current_path}/${cleaned_name_of_current_file}"
	echo "${complete_filename_of_cleaned_file}"

	#Rename file and move it back to it's original place
	mv "${detox_tmp_work_dir}/${new_name_of_current_file}" "${complete_filename_of_cleaned_file}"

	#CHANGE DETOX -- Todo: specify stricter control over detox
	#DONE -- Todo: Implement measure to ward of multiple extension attacks
	#DONE -- Todo: Input this script in the others
	#Todo: Verify file extension with the file command
	#Todo: asses security of commands used and if inputs can escape somewhere along the way, code fuzzer
	#DONE -- Todo: protect from being run as sudo
	#Todo: Unify scripts under one common utility that automatically selects the scripts depending on filetype
	#Todo: Automatically invoke script as soon as new (downloaded) file is inserted in specified folders
        shift
done
rm -rf "${detox_tmp_work_dir}"
