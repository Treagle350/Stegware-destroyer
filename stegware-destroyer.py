import os
import glob
import subprocess
from PIL import Image

input_dir="Dirty-Stegware-Folder"
tmp_dir="Temporary-stegware-processing-folder"
output_dir="Clean-Anti-Stegware-Folder"

def create_directionary(directory_name):
    if not os.path.exists(directory_name):
        os.makedirs(directory_name)

def get_download_path():
    #Needs expanding to a more robust solution
    return os.path.join(os.path.expanduser('~'), 'Downloads')

def filename_cleaner(dirty_file):
    #Pathlib could be used here: https://stackoverflow.com/questions/3548673/how-can-i-replace-or-strip-an-extension-from-a-filename-in-python
    dirty_filename = os.path.basename(dirty_file)
    dirty_filename_without_extension = os.path.splitext(dirty_filename)
    clean_filename = ""
    for each_seperate_character in dirty_filename:
        if each_seperate_character.isalnum():
            clean_filename += each_seperate_character
        else:
            clean_filename += "_"
    return clean_filename

def stegware_file_parser(old_filename_dirty_file, clean_filename):
    file_verification_output = subprocess.run(["file", old_filename_dirty_file], stdout=subprocess.PIPE).stdout.decode('utf-8')
    
    if file_verification_output[:len(old_filename_dirty_file)+len(": JPEG image data")] == (old_filename_dirty_file + ": JPEG image data"):
        verified_file_extension = "jpg"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", old_filename_dirty_file, "-c", "copy", "-vframes", "1", download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension])
    elif file_verification_output[:len(old_filename_dirty_file) + len(": PNG image data")] == (old_filename_dirty_file + ": PNG image data"):
        verified_file_extension = "png"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", old_filename_dirty_file, "-c", "copy", "-vframes", "1", download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension])
    elif file_verification_output[:len(old_filename_dirty_file) + len(": ISO Media, MP4")] == (old_filename_dirty_file + ": ISO Media, MP4"):
        verified_file_extension = "mp4"
        subprocess.run(["ffmpeg", "-hide_banner", "-loglevel", "error", "-i", old_filename_dirty_file, "-c", "copy", download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension])
    elif file_verification_output[:len(old_filename_dirty_file) + len(": PDF document, version")] == (old_filename_dirty_file + ": PDF document, version"):
        verified_file_extension = "pdf"
        #PDF -> PNG
        subprocess.run(["pdftoppm", old_filename_dirty_file, download_path + "/" + tmp_dir + "/" + "tmp", "-png"])
        #PNG -> PDF
        pdf_conversion_list_of_png_files = glob.glob(download_path + "/" + tmp_dir + "/" + "tmp*.png")
        pdf_conversion_list_of_png_files.sort()
        pdf_images = []
        for temp_img_file in pdf_conversion_list_of_png_files:
            png_file = Image.open(temp_img_file)
            pdf_images.append(png_file.convert('RGB'))
            Image.Image.close(png_file)
        pdf_images[0].save(download_path + "/" + output_dir + "/" + clean_filename + "." + verified_file_extension, "PDF", resolution=100.0, save_all=True, append_images=pdf_images[1:])
        subprocess.run(["rm", "-rf", download_path + "/" + tmp_dir])
        create_directionary(download_path + "/" + tmp_dir)
        
    else:
        print("Unsupported filetype, exiting...")
        exit()

download_path = get_download_path()
create_directionary(download_path + "/" + input_dir)
#Ensure clean start in case previous session was stopped midway
subprocess.run(["rm", "-rf", download_path + "/" + tmp_dir])
create_directionary(download_path + "/" + tmp_dir)
create_directionary(download_path + "/" + output_dir)

dirty_file_list = glob.glob(download_path + "/" + input_dir + "/*")
for dirty_file in dirty_file_list:
    clean_filename = filename_cleaner(dirty_file)
    stegware_file_parser(dirty_file, clean_filename)
subprocess.run(["rm", "-rf", download_path + "/" + tmp_dir])
