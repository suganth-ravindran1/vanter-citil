import win32com.client
import re

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # 1. Page Numbers
    for section in doc.Sections:
        for f_idx in [1, 2, 3]: # wdHeaderFooterPrimary, FirstPage, EvenPages
            try:
                footer = section.Footers(f_idx)
                rng = footer.Range
                rng.Collapse(0) # End
                rng.Fields.Add(Range=rng, Type=33) # wdFieldPage
                footer.Range.ParagraphFormat.Alignment = 1 # Center
            except: pass

    # 2. Cover Page formatting
    doc.PageSetup.DifferentFirstPageHeaderFooter = True
    
    # Align Center for cover page
    for i in range(1, 10):
        try:
            doc.Paragraphs(i).Alignment = 1
        except: pass

    # Insert Logos (From ref_doc)
    # Ref doc first page has CIT logo and Anna logo. Let's find them.
    # InlineShape 4 and 5 were in temp_pbl_final.docx Section 1 headers? No, the log said:
    # "Sec 1 Header 1: Shapes=5, InlineShapes=0 ... Shape 4: Picture 4, Shape 5: Picture 5"
    # Ah! In the final doc, the logos are floating shapes in the Header! 
    # But wait, in the cover page of the new PDF screenshot provided, they are INLINE in the page content.
    # The user says "put anna university logo as per the given template... make first page like that"
    
    # Let's extract the image from the zip file we created earlier
    import os
    cit_logo_path = r"C:\freemind mobile app\temp_pbl_template_extracted\word\media\image3.png"
    # Actually we don't know exactly which is which. Let's just insert from temp_pbl_final.docx.
    # The shapes are in the header.
    
    # Let's just fix the TOC for now
    in_toc = False
    for p in doc.Paragraphs:
        txt = p.Range.Text
        if "TABLE OF CONTENTS" in txt:
            in_toc = True
            p.Alignment = 1
            continue
            
        if in_toc and ("APPENDIX" in txt or "CHAPTER 1" in txt):
            # Do not process these
            pass
            
        if in_toc and "....." in txt:
            # Replaces text, avoiding \r
            old_txt = txt.replace("\r", "")
            new_txt = re.sub(r' \.+ ', '\t', old_txt)
            if new_txt != old_txt:
                p_rng = p.Range
                p_rng.End = p_rng.End - 1 # exclude \r
                p_rng.Text = new_txt
                
            p.TabStops.ClearAll()
            p.TabStops.Add(Position=468, Alignment=2, Leader=2)
            
        if in_toc and "APPENDIX" in txt:
            in_toc = False

    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix3.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
