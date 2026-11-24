import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False
try:
    doc = word.Documents.Open(doc_path)
    print(f"InlineShapes in doc: {doc.InlineShapes.Count}")
    for i in range(1, doc.InlineShapes.Count + 1):
        print(f"  Shape {i}: type={doc.InlineShapes(i).Type}")
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
