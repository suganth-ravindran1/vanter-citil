import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix12.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    for i, sec in enumerate(doc.Sections):
        for j in [1, 2]:
            hdr = sec.Headers(j)
            print(f"Sec {i+1} Hdr {j}: Shapes={hdr.Shapes.Count}")
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
