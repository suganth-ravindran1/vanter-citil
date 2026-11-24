import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # 1. FIX HEADERS & WATERMARK (Banner + Watermark on all pages except Page 1)
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    doc.Sections(2).PageSetup.DifferentFirstPageHeaderFooter = False
    
    # Copy from reference primary header
    ref_header = ref_doc.Sections(1).Headers(1).Range.FormattedText
    
    # Apply to Section 1 Primary Header (Page 2)
    doc.Sections(1).Headers(1).Range.FormattedText = ref_header
    
    # Apply to Section 2 Primary Header (Page 3 onwards)
    doc.Sections(2).Headers(1).LinkToPrevious = False
    doc.Sections(2).Headers(1).Range.FormattedText = ref_header
    
    # Clear Section 1 First Page Header (Page 1)
    for shape in doc.Sections(1).Headers(2).Shapes:
        shape.Delete()
    doc.Sections(1).Headers(2).Range.Delete()
    
    # 2. VISION AND MISSION BORDERS
    # We look for the 4 sections and apply orange outside border
    def apply_box(start_idx, end_idx):
        rng = doc.Range(doc.Paragraphs(start_idx).Range.Start, doc.Paragraphs(end_idx).Range.End)
        # Apply borders: Top(-1), Left(-2), Bottom(-3), Right(-4)
        for b in [-1, -2, -3, -4]:
            border = rng.Borders(b)
            border.LineStyle = 1 # wdLineStyleSingle
            border.LineWidth = 12 # 1.5 pt
            border.Color = 3243501 # Approximate RGB for Orange BGR(45, 125, 237) -> 237 + 125*256 + 45*65536 = 2981357 ... Wait, RGB(237,125,49) = 49*65536 + 125*256 + 237 = 3211501 + 32000 + 237 = 3243757. Let's use 3243757.

    v_inst_start = v_inst_end = -1
    m_inst_start = m_inst_end = -1
    v_dept_start = v_dept_end = -1
    m_dept_start = m_dept_end = -1
    
    for i, p in enumerate(doc.Paragraphs):
        txt = p.Range.Text.strip()
        if "Vision of the Institute" in txt: v_inst_start = i + 1
        elif v_inst_start != -1 and m_inst_start == -1 and "Mission of the Institute" not in txt: v_inst_end = i + 1
            
        if "Mission of the Institute" in txt: m_inst_start = i + 1
        elif m_inst_start != -1 and v_dept_start == -1 and "DEPARTMENT OF COMPUTER" not in txt and "Vision of the Department" not in txt: m_inst_end = i + 1
            
        if "Vision of the Department" in txt: v_dept_start = i + 1
        elif v_dept_start != -1 and m_dept_start == -1 and "Mission of the Department" not in txt: v_dept_end = i + 1
            
        if "Mission of the Department" in txt: m_dept_start = i + 1
        elif m_dept_start != -1 and "BONAFIDE" not in txt and txt != "": m_dept_end = i + 1
        
        if "BONAFIDE" in txt:
            break

    if v_inst_start != -1 and v_inst_end != -1: apply_box(v_inst_start, v_inst_end)
    if m_inst_start != -1 and m_inst_end != -1: apply_box(m_inst_start, m_inst_end)
    if v_dept_start != -1 and v_dept_end != -1: apply_box(v_dept_start, v_dept_end)
    if m_dept_start != -1 and m_dept_end != -1: apply_box(m_dept_start, m_dept_end)

    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix6.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Fixed headers and borders")
except Exception as e:
    print(e)
finally:
    word.Quit()
