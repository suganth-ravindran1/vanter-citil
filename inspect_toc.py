import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    print("Tables:")
    for i, t in enumerate(doc.Tables):
        try:
            print(f" Table {i+1}: rows={t.Rows.Count}, text='{t.Cell(1,1).Range.Text[:20]}'")
        except:
            pass
            
    print("Paragraphs with TOC:")
    for i, p in enumerate(doc.Paragraphs):
        if "TABLE OF CONTENTS" in p.Range.Text:
            print(f" Found at Paragraph {i}")
            
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
