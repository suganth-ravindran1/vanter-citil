import zipfile
import os

docx_path = r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx"
with zipfile.ZipFile(docx_path, 'r') as z:
    for name in z.namelist():
        if 'media' in name or 'header' in name:
            print(name)
