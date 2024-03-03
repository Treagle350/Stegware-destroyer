import os
import subprocess
from PIL import Image
import fitz

input_dir = "Dirty-Stegware-Folder"
tmp_dir = "Temporary-stegware-processing-folder"
output_dir = "Clean-Anti-Stegware-Folder"

def list_all_files_in_directory(directory):
    file_list = []
    directory_list = []
    for base_dir, directories_in_directory_contents, files_in_directory_contents in os.walk(directory):
        for file in files_in_directory_contents:
            full_file_name = os.path.join(base_dir, file)
            file_list.append(full_file_name)
        for directory in directories_in_directory_contents:
            full_dir_name = os.path.join(base_dir, directory)
            directory_list.append(full_dir_name)
    return file_list, directory_list

def create_directory(directory_name):
    if not os.path.exists(directory_name):
        os.makedirs(directory_name)
        
def delete_directory(directory_name):
    #Using os like this so I have to import less
    if os.path.exists(directory_name):
        file_list, directory_list = list_all_files_in_directory(directory_name)
        for each_file in file_list:
            os.remove(each_file)
        for each_dir in list(reversed(directory_list)):
            os.rmdir(each_dir)
        os.rmdir(directory_name)

def get_download_path():
    #Needs expanding to a more robust solution
    return os.path.join(os.path.expanduser('~'), 'Downloads')

def filename_cleaner(dirty_file):
    dirty_filename = os.path.basename(dirty_file)
    dirty_file_folder = os.path.dirname(dirty_file)
    dirty_filename_without_extension = os.path.splitext(dirty_filename)[0]
    clean_filename = ""
    for each_seperate_character in dirty_filename_without_extension:
        if each_seperate_character.isalnum():
            clean_filename += each_seperate_character
        else:
            clean_filename += "_"
    clean_filename_with_directory = os.path.join(dirty_file_folder, clean_filename)
    os.rename(dirty_file, clean_filename_with_directory)
    return clean_filename_with_directory

def pdf_cleaner(filename_dirty_pdf):
    verified_file_extension = "pdf"
    #Ensure clean start in case previous session was stopped midway
    delete_directory(os.path.join(download_path, tmp_dir))
    create_directory(os.path.join(download_path, tmp_dir))
    #PDF -> PNG
    dirty_pdf = fitz.open(filename_dirty_pdf)
    for each_page in dirty_pdf:
        current_pdf_page_pixel_map = each_page.get_pixmap(dpi=300, colorspace=fitz.csRGB, alpha=False)
        #Formatting png names so they can be sorted
        page_number = str(each_page.number)
        number_of_formatting_characters = len(str(dirty_pdf.page_count))
        formatted_page_number = page_number.zfill(number_of_formatting_characters)
        png_naming_template = "tmp" + str(formatted_page_number) + ".png"
        current_pdf_page_pixel_map.save(os.path.join(download_path, tmp_dir, png_naming_template))
    pdf_conversion_list_of_png_files = list_all_files_in_directory(os.path.join(download_path, tmp_dir))[0]
    pdf_conversion_list_of_png_files.sort()
    #PNG -> PDF
    pdf_images = []
    for each_temp_img_file in pdf_conversion_list_of_png_files:
        png_file = Image.open(each_temp_img_file)
        pdf_images.append(png_file.convert('RGB'))
        Image.Image.close(png_file)
        out_pdf_name = os.path.basename(filename_dirty_pdf) + "." + verified_file_extension
    pdf_images[0].save(os.path.join(download_path, output_dir, out_pdf_name), "PDF", resolution=100.0, save_all=True, append_images=pdf_images[1:])
    delete_directory(os.path.join(download_path, tmp_dir))

def stegware_file_parser(clean_filename_dirty_file):
    file_verification_output = subprocess.run(["file", clean_filename_dirty_file], stdout=subprocess.PIPE).stdout.decode('utf-8')
    clean_filename = os.path.basename(clean_filename_dirty_file)
    if file_verification_output[:len(clean_filename_dirty_file)+len(": JPEG image data")] == (clean_filename_dirty_file + ": JPEG image data"):
        verified_file_extension = "jpg"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", clean_filename_dirty_file, "-c", "copy", "-vframes", "1", download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension])
    elif file_verification_output[:len(clean_filename_dirty_file) + len(": PNG image data")] == (clean_filename_dirty_file + ": PNG image data"):
        verified_file_extension = "png"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", clean_filename_dirty_file, "-c", "copy", "-vframes", "1", download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension])
    elif file_verification_output[:len(clean_filename_dirty_file) + len(": ISO Media, MP4")] == (clean_filename_dirty_file + ": ISO Media, MP4"):
        verified_file_extension = "mp4"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", clean_filename_dirty_file, "-c", "copy", download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension])
    elif file_verification_output[:len(clean_filename_dirty_file) + len(": PDF document, version")] == (clean_filename_dirty_file + ": PDF document, version"):
        pdf_cleaner(clean_filename_dirty_file)
    else:
        print("Unsupported filetype, exiting...")
        exit()

download_path = get_download_path()
create_directory(os.path.join(download_path, input_dir))
create_directory(os.path.join(download_path, output_dir))

#Deal with folders
dirty_file_list, directory_list = list_all_files_in_directory(os.path.join(download_path, input_dir))
for dirty_file in dirty_file_list:
    clean_filename_of_dirty_file = filename_cleaner(dirty_file)
    stegware_file_parser(clean_filename_of_dirty_file)
#delete_directory(os.path.join(download_path, input_dir))