import win32com.client
import os

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

src_docx = os.path.abspath(r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx")
print("Opening:", src_docx)
doc = word.Documents.Open(src_docx)
print("Sections count:", doc.Sections.Count)
print("Paragraphs count:", doc.Paragraphs.Count)
print("Tables count:", doc.Tables.Count)

doc.Close(False)
word.Quit()
print("Success!")
