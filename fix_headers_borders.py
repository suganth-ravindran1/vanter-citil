import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # Ensure Section 1 has Different First Page
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    # Clear the cover page header (FirstPage is index 2)
    for shape in doc.Sections(1).Headers(2).Shapes:
        shape.Delete()
    doc.Sections(1).Headers(2).Range.Delete()

    # Section 2 doesn't need different first page, so it uses Primary Header
    doc.Sections(2).PageSetup.DifferentFirstPageHeaderFooter = False
    
    # We copy the Primary Header (index 1) from ref_doc to Section 2 Header 1
    doc.Sections(2).Headers(1).LinkToPrevious = False
    doc.Sections(2).Headers(1).Range.FormattedText = ref_doc.Sections(1).Headers(1).Range.FormattedText
    
    # We copy the Primary Header (index 1) from ref_doc to Section 1 Header 1 (Page 2)
    doc.Sections(1).Headers(1).Range.FormattedText = ref_doc.Sections(1).Headers(1).Range.FormattedText
    
    # Delete watermarks from Section 1 Header 1 (so Page 2 has no watermark)
    shapes_to_del = []
    for i in range(1, doc.Sections(1).Headers(1).Shapes.Count + 1):
        name = doc.Sections(1).Headers(1).Shapes(i).Name
        if "Watermark" in name:
            shapes_to_del.append(doc.Sections(1).Headers(1).Shapes(i))
    for s in shapes_to_del:
        s.Delete()

    # Remove TOC Borders
    in_toc = False
    for p in doc.Paragraphs:
        txt = p.Range.Text.strip()
        if "TABLE OF CONTENTS" in txt:
            in_toc = True
        if in_toc and "CHAPTER 1" in txt:
            break
        if in_toc:
            p.Borders(-1).LineStyle = 0 # Top
            p.Borders(-2).LineStyle = 0 # Left
            p.Borders(-3).LineStyle = 0 # Bottom
            p.Borders(-4).LineStyle = 0 # Right
            
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix5.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Fix 5 done")
except Exception as e:
    print(e)
finally:
    word.Quit()
