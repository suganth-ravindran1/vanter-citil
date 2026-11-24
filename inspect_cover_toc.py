import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    
    print(f"DifferentFirstPageHeaderFooter: {doc.PageSetup.DifferentFirstPageHeaderFooter}")
    
    # Inspect first few paragraphs for the cover page
    for i in range(15):
        print(f"P{i}: '{doc.Paragraphs(i+1).Range.Text.strip()}'")

    # Inspect TOC paragraphs
    in_toc = False
    for p in doc.Paragraphs:
        txt = p.Range.Text.strip()
        if "TABLE OF CONTENTS" in txt:
            in_toc = True
            print("TOC Start found")
        elif in_toc and txt.startswith("CHAPTER 1"):
            print(f"TOC Sample: '{txt}'")
            in_toc = False
            
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
