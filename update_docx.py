import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    
    # 1. Update font and alignment for all text
    for p in doc.Paragraphs:
        try:
            style_name = p.Style.NameLocal
        except:
            style_name = ""
            
        if "Heading" in style_name:
            p.Range.Font.Name = "Times New Roman"
            p.Range.Font.Size = 14
            p.Alignment = 1 # wdAlignParagraphCenter
        else:
            p.Range.Font.Name = "Times New Roman"
            p.Range.Font.Size = 12
            p.Alignment = 3 # wdAlignParagraphJustify

    # 2. Page borders removal
    for section in doc.Sections:
        for border in section.Borders:
            border.LineStyle = 0 # wdLineStyleNone
            
    # 3. Vision/Mission box auto-fit
    for table in doc.Tables:
        table.AllowAutoFit = True
        table.AutoFitBehavior(2) # wdAutoFitWindow

    # 4. Remove watermark from first 2 pages
    word.Selection.HomeKey(Unit=6) # wdStory
    word.Selection.GoTo(What=1, Which=1, Count=3) # Go to page 3
    
    word.Selection.InsertBreak(Type=3) # wdSectionBreakContinuous
    
    for header in doc.Sections(2).Headers:
        header.LinkToPrevious = False
        
    for header in doc.Sections(1).Headers:
        shapes_to_delete = []
        for i in range(1, header.Shapes.Count + 1):
            if "Watermark" in header.Shapes(i).Name:
                shapes_to_delete.append(header.Shapes(i))
        for shape in shapes_to_delete:
            shape.Delete()
                
    doc.SaveAs(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Updated.docx")
    doc.Close(False)
    print("Done")
except Exception as e:
    print(e)
finally:
    word.Quit()
