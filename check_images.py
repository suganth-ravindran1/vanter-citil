import zipfile
from PIL import Image
import io

docx_path = r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx"
with zipfile.ZipFile(docx_path, 'r') as z:
    for name in sorted(z.namelist()):
        if name.startswith('word/media/'):
            data = z.read(name)
            img = Image.open(io.BytesIO(data))
            print(f"{name}: size={img.size}, format={img.format}, len={len(data)}")
