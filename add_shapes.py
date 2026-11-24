import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
banner_path = r"C:\freemind mobile app\temp_pbl_final_extracted\word\media\image4.png"
watermark_path = r"C:\freemind mobile app\temp_pbl_final_extracted\word\media\image6.png"

word = win32com.client.Dispatch("Word.Application")
word.Visible = False
word.DisplayAlerts = False

try:
    doc = word.Documents.Open(doc_path)
    
    # 1. Section 1 Setup
    doc.Sections(1).PageSetup.DifferentFirstPageHeaderFooter = True
    
    # Clear headers first
    for j in [1, 2]:
        for s in doc.Sections(1).Headers(j).Shapes: s.Delete()
        for s in doc.Sections(2).Headers(j).Shapes: s.Delete()
    
    # 2. Insert into Primary Header (which affects Page 2 of Sec 1, and all of Sec 2)
    def insert_headers(sec_idx):
        hdr = doc.Sections(sec_idx).Headers(1) # Primary Header
        
        # Insert Banner
        banner = hdr.Shapes.AddPicture(FileName=banner_path, LinkToFile=False, SaveWithDocument=True)
        # Position banner at very top
        banner.RelativeHorizontalPosition = 1 # wdRelativeHorizontalPositionMargin
        banner.RelativeVerticalPosition = 1 # wdRelativeVerticalPositionMargin
        banner.Left = -36 # Adjust roughly to page edges
        banner.Top = -36
        banner.Width = 600
        banner.ZOrder(5) # Send behind text
        
        # Insert Watermark
        watermark = hdr.Shapes.AddPicture(FileName=watermark_path, LinkToFile=False, SaveWithDocument=True)
        watermark.RelativeHorizontalPosition = 1
        watermark.RelativeVerticalPosition = 1
        watermark.Left = -50
        watermark.Top = 150
        watermark.Width = 600
        watermark.ZOrder(5) # Send behind text
        
        # Make watermark transparent / washed out
        watermark.PictureFormat.Brightness = 0.85
        watermark.PictureFormat.Contrast = 0.15

    insert_headers(1)
    
    # Unlink Section 2 from Section 1 just in case, and insert
    doc.Sections(2).Headers(1).LinkToPrevious = False
    insert_headers(2)
    doc.Sections(2).PageSetup.DifferentFirstPageHeaderFooter = False

    # 3. Vision & Mission Outline Borders
    # Find start and end paragraphs
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

    def apply_box(s, e):
        if s != -1 and e != -1:
            try:
                r = doc.Range(doc.Paragraphs(s).Range.Start, doc.Paragraphs(e).Range.End)
                for b in [-1, -2, -3, -4]:
                    border = r.Borders(b)
                    border.LineStyle = 1
                    border.LineWidth = 12
                    border.Color = 3243757
            except: pass

    apply_box(v_inst_start, v_inst_end)
    apply_box(m_inst_start, m_inst_end)
    apply_box(v_dept_start, v_dept_end)
    apply_box(m_dept_start, m_dept_end)

    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix12.docx")
    doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
