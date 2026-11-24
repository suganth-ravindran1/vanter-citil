import win32com.client
import os
import traceback

source_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"
target_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    source_doc = word.Documents.Open(source_path)
    target_doc = word.Documents.Open(target_path)
    
    for h_idx in range(1, 4):
        # 1 = wdHeaderFooterPrimary, 2 = FirstPage, 3 = EvenPages
        source_header = source_doc.Sections(1).Headers(h_idx)
        target_header_sec1 = target_doc.Sections(1).Headers(h_idx)
        target_header_sec2 = target_doc.Sections(2).Headers(h_idx)
        
        target_header_sec2.LinkToPrevious = False
        target_header_sec2.Range.FormattedText = source_header.Range.FormattedText
        
        target_header_sec1.Range.FormattedText = source_header.Range.FormattedText
        
        shapes_to_del = []
        for i in range(1, target_header_sec1.Shapes.Count + 1):
            if "Watermark" in target_header_sec1.Shapes(i).Name:
                shapes_to_del.append(target_header_sec1.Shapes(i))
        for shape in shapes_to_del:
            shape.Delete()

    # Now handle TOC box border
    in_toc = False
    toc_start = None
    toc_end = None
    for p in target_doc.Paragraphs:
        txt = p.Range.Text.strip()
        if "TABLE OF CONTENTS" in txt:
            in_toc = True
            toc_start = p.Range.Start
        elif in_toc and txt.startswith("APPENDIX"):
            toc_end = p.Range.End
            break
            
    if toc_start and toc_end:
        rng = target_doc.Range(toc_start, toc_end)
        # wdBorderLeft=-2, wdBorderRight=-4, wdBorderTop=-1, wdBorderBottom=-3, wdBorderOutside=-5
        rng.Borders(-2).LineStyle = 1 # wdLineStyleSingle
        rng.Borders(-4).LineStyle = 1
        rng.Borders(-1).LineStyle = 1
        rng.Borders(-3).LineStyle = 1
        # Set padding or just let it be

    target_doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fixed.docx")
    source_doc.Close(False)
    target_doc.Close(False)
    print("Fixed!")
except Exception as e:
    print("Error:", e)
    traceback.print_exc()
finally:
    word.Quit()
