import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    ref_doc = word.Documents.Open(final_path)
    
    doc.Content.Copy()
    
    # Select all but the last paragraph mark to preserve section breaks
    rng = ref_doc.Range(ref_doc.Content.Start, ref_doc.Content.End - 1)
    rng.Delete()
    rng.Paste()
    
    # Now set the headers
    # Section 1 DifferentFirstPage = True
    ref_doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    
    # Delete shapes in Section 1 FirstPage Header
    for s in ref_doc.Sections(1).Headers(2).Shapes:
        s.Delete()
    ref_doc.Sections(1).Headers(2).Range.Delete()
    
    # Section 2 DifferentFirstPage = False
    for sec_idx in range(2, ref_doc.Sections.Count + 1):
        ref_doc.Sections(sec_idx).PageSetup.DifferentFirstPageHeaderFooter = False

    # Apply Vision/Mission borders
    def apply_box(start_idx, end_idx):
        try:
            r = ref_doc.Range(ref_doc.Paragraphs(start_idx).Range.Start, ref_doc.Paragraphs(end_idx).Range.End)
            for b in [-1, -2, -3, -4]:
                border = r.Borders(b)
                border.LineStyle = 1
                border.LineWidth = 12
                border.Color = 3243757
        except: pass

    v_inst_start = v_inst_end = -1
    m_inst_start = m_inst_end = -1
    v_dept_start = v_dept_end = -1
    m_dept_start = m_dept_end = -1
    
    for i, p in enumerate(ref_doc.Paragraphs):
        txt = p.Range.Text.strip()
        if "Vision of the Institute" in txt: v_inst_start = i + 1
        elif v_inst_start != -1 and m_inst_start == -1 and "Mission of the Institute" not in txt: v_inst_end = i + 1
            
        if "Mission of the Institute" in txt: m_inst_start = i + 1
        elif m_inst_start != -1 and v_dept_start == -1 and "DEPARTMENT OF COMPUTER" not in txt and "Vision of the Department" not in txt: m_inst_end = i + 1
            
        if "Vision of the Department" in txt: v_dept_start = i + 1
        elif v_dept_start != -1 and m_dept_start == -1 and "Mission of the Department" not in txt: v_dept_end = i + 1
            
        if "Mission of the Department" in txt: m_dept_start = i + 1
        elif m_dept_start != -1 and "BONAFIDE" not in txt and txt != "": m_dept_end = i + 1
        
        if "BONAFIDE" in txt: break

    apply_box(v_inst_start, v_inst_end)
    apply_box(m_inst_start, m_inst_end)
    apply_box(v_dept_start, v_dept_end)
    apply_box(m_dept_start, m_dept_end)

    ref_doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix10.docx")
    
    doc.Close(False)
    ref_doc.Close(False)
    print("Done Final")
except Exception as e:
    print(e)
finally:
    word.Quit()
