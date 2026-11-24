import win32com.client
import os

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

src_docx = os.path.abspath(r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx")
doc = word.Documents.Open(src_docx)

print("Shapes in doc.Shapes:", doc.Shapes.Count)
for i in range(1, doc.Shapes.Count + 1):
    shape = doc.Shapes(i)
    text = ""
    try:
        if shape.TextFrame.HasText:
            text = shape.TextFrame.TextRange.Text.strip().replace('\r', ' ')
    except:
        pass
    print(f"Shape {i}: type={shape.Type}, name={shape.Name}, text={text[:60]}")

doc.Close(False)
word.Quit()
