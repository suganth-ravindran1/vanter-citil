import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path)
    
    # Copy all content from doc
    doc.Content.Copy()
    
    # Delete all content from ref_doc
    ref_doc.Content.Delete()
    
    # Paste into ref_doc
    ref_doc.Content.Paste()
    
    # Now ref_doc has the text, but let's check its headers
    ref_doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix9.docx")
    
    doc.Close(False)
    ref_doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
