import win32com.client
import os

career_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = False

try:
    doc = word.Documents.Open(career_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # 1. Page Numbers at the bottom
    for section in doc.Sections:
        footer = section.Footers(1) # Primary footer
        # Insert page number
        # wdFieldPage = 33
        word.Selection.GoTo(What=10, Which=1) # No, better use Range
        rng = footer.Range
        rng.Collapse(0) # End
        rng.Fields.Add(Range=rng, Type=33)
        footer.Range.ParagraphFormat.Alignment = 1 # Center
        
        # If there's a different first page footer, do it there too
        if section.PageSetup.DifferentFirstPageHeaderFooter:
            footer_fp = section.Footers(2)
            rng2 = footer_fp.Range
            rng2.Collapse(0)
            rng2.Fields.Add(Range=rng2, Type=33)
            footer_fp.Range.ParagraphFormat.Alignment = 1
            
    # 2. Cover Page formatting
    doc.PageSetup.DifferentFirstPageHeaderFooter = True
    # The first page header is now blank, so the banner is removed from the first page.
    
    # Center text on the first page
    for i in range(1, 8):
        try:
            doc.Paragraphs(i).Alignment = 1 # Center
        except:
            pass

    # We need to insert the logos. Let's copy them from ref_doc cover page.
    # ref_doc first page has them. Let's find InlineShapes.
    cit_logo = None
    anna_logo = None
    if ref_doc.InlineShapes.Count >= 2:
        cit_logo = ref_doc.InlineShapes(1)
        anna_logo = ref_doc.InlineShapes(2)
        
    if cit_logo and anna_logo:
        # We will insert CIT logo before "CHENNAI INSTITUTE OF TECHNOLOGY, CHENNAI"
        # and Anna logo after it.
        # Let's find "CHENNAI INSTITUTE OF TECHNOLOGY, CHENNAI" in the first 10 paragraphs
        for i in range(1, 10):
            txt = doc.Paragraphs(i).Range.Text
            if "CHENNAI INSTITUTE" in txt:
                cit_logo.Range.Copy()
                rng_cit = doc.Paragraphs(i).Range
                rng_cit.Collapse(1) # Start
                rng_cit.Paste()
                
                # Now the index might shift, let's just find "CHENNAI INSTITUTE" again
                break
                
        for i in range(1, 12):
            txt = doc.Paragraphs(i).Range.Text
            if "CHENNAI INSTITUTE" in txt:
                anna_logo.Range.Copy()
                rng_anna = doc.Paragraphs(i).Range
                rng_anna.Collapse(0) # End
                # We need it after the paragraph, so next paragraph start
                rng_anna = doc.Paragraphs(i+1).Range
                rng_anna.Collapse(1)
                rng_anna.Paste()
                break

    # 3. TOC Formatting
    # We replace " ...." with a Tab, and set Tab stop
    in_toc = False
    for p in doc.Paragraphs:
        txt = p.Range.Text.strip()
        if "TABLE OF CONTENTS" in txt:
            in_toc = True
            p.Alignment = 1 # Center the title
            continue
            
        if in_toc and txt.startswith("CHAPTER 1"):
            # Don't break, just process TOC lines
            pass
            
        if in_toc and "....." in txt:
            # It's a TOC line
            rng = p.Range
            rng.Find.Execute(FindText=" .", ReplaceWith="\t", Replace=2) # wdReplaceAll=2
            # Add right-aligned tab stop with dots
            p.TabStops.ClearAll()
            # 6.5 inches = 6.5 * 72 = 468 points
            p.TabStops.Add(Position=468, Alignment=2, Leader=2)
            
        if in_toc and txt.startswith("APPENDIX"):
            in_toc = False
            
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix2.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
