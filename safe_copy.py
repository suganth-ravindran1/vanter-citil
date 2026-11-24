import win32com.client
import time

career_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
final_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_final.docx"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = False

try:
    doc = word.Documents.Open(career_path)
    ref_doc = word.Documents.Open(final_path, ReadOnly=True)
    
    # Configure Section 1 (Page 1) to be blank header
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    for s in doc.Sections(1).Headers(2).Shapes: s.Delete()
    doc.Sections(1).Headers(2).Range.Delete()

    # Section 2 doesn't need different first page
    doc.Sections(2).PageSetup.DifferentFirstPageHeaderFooter = False
    
    # We want to use ref_doc's Sec 1 Header 1 shapes and copy them
    ref_hdr = ref_doc.Sections(1).Headers(1)
    
    # Delete existing shapes in doc's primary headers
    for s in doc.Sections(1).Headers(1).Shapes: s.Delete()
    for s in doc.Sections(2).Headers(1).Shapes: s.Delete()
    
    # We need to be active in the document to paste safely
    doc.Activate()
    
    for i in range(1, ref_hdr.Shapes.Count + 1):
        try:
            shp = ref_hdr.Shapes(i)
            shp.Select()
            word.Selection.Copy()
            
            # Paste into Sec 1 Header 1 (Page 2)
            word.ActiveWindow.ActivePane.View.SeekView = 9 # wdSeekPrimaryHeader
            # We are now in Primary Header of whatever page we are on. 
            # Better to use Range.Paste()
            doc.Sections(1).Headers(1).Range.Paste()
            doc.Sections(2).Headers(1).Range.Paste()
        except: pass
        
    word.ActiveWindow.ActivePane.View.SeekView = 0 # wdSeekMainDocument
    
    # Apply borders for Vision/Mission
    def apply_box(start_idx, end_idx):
        try:
            r = doc.Range(doc.Paragraphs(start_idx).Range.Start, doc.Paragraphs(end_idx).Range.End)
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
        
        if "BONAFIDE" in txt: break

    apply_box(v_inst_start, v_inst_end)
    apply_box(m_inst_start, m_inst_end)
    apply_box(v_dept_start, v_dept_end)
    apply_box(m_dept_start, m_dept_end)
    
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix11.docx")
    doc.Close(False)
    ref_doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
