# Stegware-removal-tools
A set of bash (linux) scripts that remove stegware from documents. The script **ffmpeg-file-cleaner.sh** cleans videos and images by reencoding the data headers, while the script **pdf-cleaner.sh** cleans pdf files by converting them into png files and then back into pdf files. This process naturally removes any javascript the pdfs might have had.

>[!WARNING]
>Keep the scripts stored in the same folder, some scripts reference one another. By default they expect the others to be in the same folder.

> [!CAUTION]
> By default the scripts overwrite and replace the input file.

## Prerequisites
You need to install the following packages to be able to use the scripts :
* Poppler-utils
> Installable via package manager. Also known as **poppler-utils** in Debian, Ubuntu, Mint, RHEL, CentOS, Fedora. Also known as **poppler-tools** in OpenSUSE. Also known as **poppler** in Arch, Alpine.

* Img2pdf
> Installable via package manager or the python3 tool pip.

* Ffmpeg
> Installable via package manager.

## Running
1. Download the files **ffmpeg-file-cleaner.sh** and **pdf-cleaner.sh** and open a terminal in the folder of the files
2. Run the command **chmod +x ffmpeg-file-cleaner.sh && chmod +x pdf-cleaner.sh** in the terminal to make the scripts executable
3. Execute the scripts with **"./ffmpeg-file-cleaner.sh"** and **"./pdf-cleaner.sh"** respectively

### Project status
This project works but has not been rigorously tested yet to prove its efficiency in stegware/malware removal, consider it to be a prototype/concept more than a finished version as of now.
