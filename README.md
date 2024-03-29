# Stegware-destroyer
A python3 script that cleans documents by recreating them partially. It uses ffmpeg to clean headers of images and movies, pdf files are cleaned by turning them into images and then back into a pdf. This removes javascript from the pdfs.

Upon first running the program it creates two folders in the Downloads folder of your Linux PC. One named **Dirty-Stegware-Folder** and the other named **Clean-Anti-Stegware-Folder**. Place your untrusted files in the 'Dirty-Stegware-Folder', run the script and find your clean files in the 'Clean-Anti-Stegware-Folder'.

>[!WARNING]
>Currently the tools only support PNG, JPEG, MP4 and PDF's. Others are a work in progress.

## Prerequisites
You need to install the following packages to be able to use the scripts :

* Ffmpeg
> Installable via package manager.

```sudo apt install ffmpeg```

* [Pillow](https://pypi.org/project/pillow/) (PIL) Python package
* [PyMuPDF](https://pypi.org/project/PyMuPDF/) (Fitz) Python package
* [Fleep](https://pypi.org/project/fleep/) (fleep) Python package
> Installable with pip

```sudo apt install python3-pip && pip install Pillow && pip install PyMuPDF && pip install fleep```

## Running
```python3 stegware-destroyer.py```

### Project status
This project works but has not been rigorously tested yet to prove its efficiency in stegware/malware removal, consider it to be a prototype/concept more than a finished version as of now.

#### Project roadmap
Todo: Automatically invoke script as soon as new (downloaded) file is inserted in specified folders

Todo: Implement other filetypes
