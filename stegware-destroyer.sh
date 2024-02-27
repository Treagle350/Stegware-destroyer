#! /bin/bash

if [[ "$EUID" = 0 ]]; then
	echo "Never use sudo or a root account for trivial stuff, you're inviting disasters and viruses in..."
	echo "Program is quitting and didn't execute anything..."
	exit
fi

#####Begin variables specification#####
#This section contains all variables users can modify, which folders are used for processing and if dirty files should be removed or not
input_dir="/home/$USER/Downloads/Dirty-Stegware-Folder"
output_dir="/home/$USER/Downloads/Clean-Anti-Stegware-Folder"
#If set to "true" the dirty folder contents will be deleted, otherwise it will be kept
overwrite_flag=false
#####End variables specification#####

if [[ ! -d "${input_dir}" ]]; then
	mkdir "${input_dir}"
fi
if [[ ! -d "${output_dir}" ]]; then
	mkdir "${output_dir}"
fi
detox_tmp_work_dir="/tmp/super-hacky-way-of-getting-the-output-filenames-from-detox"
tmp_img_proc_dir="/tmp/temp-imgs-pdf-conversion"
#Cleanup if previous session was abrupted midway
rm -rf "${detox_tmp_work_dir}"
rm -rf "${tmp_img_proc_dir}"
mkdir "${detox_tmp_work_dir}"
mkdir "${tmp_img_proc_dir}"

for i in "${input_dir}/"*""; do
	#TODO: Clean folders too
	current_path="${input_dir}"
	#Take the files to a temporary work environment
	if [[ "${overwrite_flag}" = true ]]; then
		echo "Overwrite enabled"
		mv "${i}" "${detox_tmp_work_dir}"
	else
		echo "Overwrite disabled"
		cp "${i}" "${detox_tmp_work_dir}"
	fi
        #Remove all suspicious characters
        detox -r "${detox_tmp_work_dir}"

	#Get new filename
	new_name_of_current_file="$(ls ${detox_tmp_work_dir} | head -1)"

	#Get extension by issuing file command because we're assuming the filename is lying
	tested_extension="$(file ${detox_tmp_work_dir}/${new_name_of_current_file})"
        case "$tested_extension" in
                "${detox_tmp_work_dir}/${new_name_of_current_file}: JPEG image data"*"")
                 calculated_extension="jpg"
		 #Destroy all metadata by keeping the data itself and recreating the data headers around them
        	 #Hide banner and logging except for errors because ffmpeg is way too verbose
        	 #vframes 1 disables image sequencing, when an input image has multiple layers omit the others and only use the base image
		 ffmpeg -hide_banner -loglevel error -i "${detox_tmp_work_dir}/${new_name_of_current_file}" -c copy -vframes 1 "${detox_tmp_work_dir}/cleaned_${new_name_of_current_file}"
                 ;;
                "${detox_tmp_work_dir}/${new_name_of_current_file}: PNG image data"*"")
                 calculated_extension="png"
                 #Destroy all metadata by keeping the data itself and recreating the data headers around them
                 #Hide banner and logging except for errors because ffmpeg is way too verbose
                 #vframes 1 disables image sequencing, when an input image has multiple layers omit the others and only use the base image
                 ffmpeg -hide_banner -loglevel error -i "${detox_tmp_work_dir}/${new_name_of_current_file}" -c copy -vframes 1 "${detox_tmp_work_dir}/cleaned_${new_name_of_current_file}"
		 ;;
                "${detox_tmp_work_dir}/${new_name_of_current_file}: GIF image data"*"")
                 calculated_extension="gif"
                 ;;
                "${detox_tmp_work_dir}/${new_name_of_current_file}: ISO Media, MP4"*"")
                 calculated_extension="mp4"
		 #Destroy all metadata by keeping the data itself and recreating the data headers around them
		 #Hide banner and logging except for errors because ffmpeg is way too verbose
		 ffmpeg -hide_banner -loglevel error -i "${detox_tmp_work_dir}/${new_name_of_current_file}" -c copy "${detox_tmp_work_dir}/cleaned_${new_name_of_current_file}"
		 ;;
                "${detox_tmp_work_dir}/${new_name_of_current_file}: RIFF (little-endian) data, AVI"*"")
                 calculated_extension="avi"
                 ;;
                "${detox_tmp_work_dir}/${new_name_of_current_file}: PDF document, version"*"")
                 calculated_extension="pdf"
		 #PNG files have less complicated metadata fields so less attack surface
	         pdftoppm "${detox_tmp_work_dir}/${new_name_of_current_file}" "${tmp_img_proc_dir}/out" -png
		 #ffmpeg could be included here to clean headers of generated pngs, but we'll consider them clean
		 img2pdf "${tmp_img_proc_dir}/out"*".png" -o "${detox_tmp_work_dir}/cleaned_${new_name_of_current_file}"
		 #Remove all images to prepare for next pdf
		 rm "${tmp_img_proc_dir}/out"*".png"
                 ;;
                ""*"")
                 calculated_extension="unknown"
		 echo "Filetype unknown to script, only renamed the filename to a safer alternative"
		 echo "The file contents have not been altered, exiting..."
		 mv "${detox_tmp_work_dir}/${new_name_of_current_file}" "${i}"
		 exit
                 ;;
        esac
	#Remove dirty file in temporary directory
	rm "${detox_tmp_work_dir}/${new_name_of_current_file}"
	#Create new filename without mutiple extensions
	new_name_of_current_file_with_removed_extension="${new_name_of_current_file%.*}"
	new_name_of_current_file_with_removed_extension_and_dots="${new_name_of_current_file_with_removed_extension//./}"
	cleaned_name_of_current_file="${new_name_of_current_file_with_removed_extension_and_dots}.${calculated_extension}"

	complete_filename_of_cleaned_file="${output_dir}/${cleaned_name_of_current_file}"

	#Rename file and move it back to it's new place
	mv "${detox_tmp_work_dir}/cleaned_${new_name_of_current_file}" "${complete_filename_of_cleaned_file}"
done
rm -rf "${detox_tmp_work_dir}"
rm -rf "${tmp_img_proc_dir}"
