# Stegware-removal-tools
A set of bash (linux) scripts that remove stegware from documents. 
* The script **ffmpeg-file-cleaner.sh** cleans videos and images by reencoding the data headers.
* The script **pdf-cleaner.sh** cleans pdf files by converting them into png files and then back into pdf files. This process naturally removes any javascript the pdfs might have had.

The following scripts are also provided but are embedded within the scripts mentioned above, therefore they're not intended to be run alone
* The script **file-name-cleaner.sh** removes multiple extensions and gives one extension to the file as well as remove all special characters that might fool users and programs alike.
* The script **file-extension-verifier.sh** validates that the file extension matches the content of the file.

Currently the tools only support PNG,JPEG and PDF's. Others are a work in progress.

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

* Detox
> Installable via package manager or via [git](https://github.com/dharple/detox).

## Running
1. Download the files **ffmpeg-file-cleaner.sh** and **pdf-cleaner.sh** and open a terminal in the folder of the files
2. Run the command **chmod +x ffmpeg-file-cleaner.sh && chmod +x pdf-cleaner.sh** in the terminal to make the scripts executable
3. Execute the scripts with **"./ffmpeg-file-cleaner.sh"** and **"./pdf-cleaner.sh"** respectively

### Project status
This project works but has not been rigorously tested yet to prove its efficiency in stegware/malware removal, consider it to be a prototype/concept more than a finished version as of now.

#### Project roadmap
Todo: Unify scripts under one common utility that automatically selects the scripts depending on filetype

Todo: Automatically invoke script as soon as new (downloaded) file is inserted in specified folders

Todo: Implement other filetypes
