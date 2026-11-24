import win32com.client
import time

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # We copy shapes from ref_doc Sec 1 Header 1 to doc Sec 1 Header 1 and Sec 2 Header 1
    ref_shapes = ref_doc.Sections(1).Headers(1).Shapes
    print(f"Found {ref_shapes.Count} shapes in ref_doc")
    
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    
    target_hdr1 = doc.Sections(1).Headers(1)
    target_hdr2 = doc.Sections(2).Headers(1)
    
    # Clean up existing shapes just in case
    for s in target_hdr1.Shapes: s.Delete()
    for s in target_hdr2.Shapes: s.Delete()
    
    # Iterate and copy
    for i in range(1, ref_shapes.Count + 1):
        try:
            shp = ref_shapes(i)
            shp.Select()
            word.Selection.Copy()
            
            # Paste into target header 1 (Section 1)
            target_hdr1.Range.Select()
            word.Selection.Paste()
            
            # Paste into target header 2 (Section 2)
            target_hdr2.Range.Select()
            word.Selection.Paste()
            
        except Exception as e:
            print(f"Failed to copy shape {i}: {e}")

    # Ensure FirstPage header is blank in Sec 1
    doc.Sections(1).Headers(2).Range.Delete()
    for s in doc.Sections(1).Headers(2).Shapes: s.Delete()
            
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix8.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
