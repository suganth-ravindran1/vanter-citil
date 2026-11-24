import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # We want to copy the contents of ref_doc Section 1 Header 1 to:
    # 1. doc Section 1 Header 1 (Page 2)
    # 2. doc Section 2 Header 1 (Page 3 onwards)
    
    # First, let's copy the entire header range using copy/paste instead of FormattedText
    # This usually brings shapes along!
    ref_hdr = ref_doc.Sections(1).Headers(1).Range
    ref_hdr.Copy()
    
    target_hdr1 = doc.Sections(1).Headers(1).Range
    target_hdr1.Paste()
    
    target_hdr2 = doc.Sections(2).Headers(1).Range
    target_hdr2.Paste()
    
    # We must ensure Section 1 FirstPage header is blank
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    doc.Sections(1).Headers(2).Range.Delete()
    for shp in doc.Sections(1).Headers(2).Shapes:
        shp.Delete()
        
    doc.Sections(2).PageSetup.DifferentFirstPageHeaderFooter = False
    doc.Sections(2).Headers(1).LinkToPrevious = False
    
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix7.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
