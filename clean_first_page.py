import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix12.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    # Be absolutely sure
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    # Delete shapes from first page header
    shapes_to_delete = []
    for s in doc.Sections(1).Headers(2).Shapes:
        shapes_to_delete.append(s)
    for s in shapes_to_delete:
        s.Delete()
    
    # Just to be completely certain, delete inline shapes too
    inlines_to_delete = []
    for s in doc.Sections(1).Headers(2).Range.InlineShapes:
        inlines_to_delete.append(s)
    for s in inlines_to_delete:
        s.Delete()
        
    doc.Sections(1).Headers(2).Range.Delete()
    
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix13.docx")
    doc.Close(False)
    print("Cleaned First Page")
except Exception as e:
    print(e)
finally:
    word.Quit()
