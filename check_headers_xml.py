import zipfile

docx_path = r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx"
with zipfile.ZipFile(docx_path, 'r') as z:
    for h in ['word/header1.xml', 'word/header2.xml', 'word/header3.xml', 'word/header4.xml', 'word/header5.xml']:
        try:
            content = z.read(h).decode('utf-8')
            print(f"=== {h} (len={len(content)}) ===")
            print(content[:500])
        except Exception as e:
            print(f"Error {h}: {e}")
