import win32com.client
import traceback

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    print("Sections:", doc.Sections.Count)
    for i, sec in enumerate(doc.Sections):
        print(f"\nSection {i+1}:")
        print(f" DifferentFirstPage: {sec.PageSetup.DifferentFirstPageHeaderFooter}")
        for j in range(1, 4):
            hdr = sec.Headers(j)
            print(f" Header {j} (1=Primary, 2=FirstPage, 3=Even): Shapes={hdr.Shapes.Count}, InlineShapes={hdr.Range.InlineShapes.Count}")
            
    # Check TOC Borders
    in_toc = False
    for p in doc.Paragraphs:
        if "TABLE OF CONTENTS" in p.Range.Text:
            in_toc = True
            print("\nTOC found. Borders applied?")
            print(f" Top: {p.Borders(-1).LineStyle}, Bottom: {p.Borders(-3).LineStyle}")
        if in_toc and "CHAPTER 1" in p.Range.Text:
            break
            
    doc.Close(False)
except Exception as e:
    traceback.print_exc()
finally:
    word.Quit()
