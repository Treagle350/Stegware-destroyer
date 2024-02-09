# Stegware-removal-tools
A set of bash (linux) scripts that remove stegware from documents. The script **ffmpeg-file-cleaner.sh** cleans videos and images by reencoding the data headers, while the script **pdf-cleaner.sh** cleans pdf files by converting them into png files and then back into pdf files. This process naturally removes any javascript the pdfs might have had.

>[!WARNING]
>Keep the scripts stored in the same folder, some scripts reference one another. By default they expect the others to be in the same folder.

## Prerequisites
You need to install the following packages to be able to use the scripts :
* Poppler-utils
> Installable via package manager. Also known as **poppler-utils** in Debian, Ubuntu, Mint, RHEL, CentOS, Fedora. Also known as **poppler-tools** in OpenSUSE. Also known as **poppler** in Arch, Alpine.

* Img2pdf
> Installable via package manager or the python3 tool pip.

* Ffmpeg
> Installable via package manager.
