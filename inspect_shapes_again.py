import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    print("Sections:", doc.Sections.Count)
    for i, sec in enumerate(doc.Sections):
        print(f"Section {i+1}:")
        for j in [1, 2, 3]:
            hdr = sec.Headers(j)
            print(f"  Header {j}: {hdr.Shapes.Count} Shapes")
            for k in range(1, hdr.Shapes.Count + 1):
                print(f"    Shape {k}: {hdr.Shapes(k).Name}")
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
