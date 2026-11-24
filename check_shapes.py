import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    
    # Let's inspect the sections and watermarks
    print(f"Sections: {doc.Sections.Count}")
    
    for i, section in enumerate(doc.Sections):
        print(f"Section {i+1}:")
        print(" Headers in section:")
        for header in section.Headers:
            print(f"  Header type: {header.Index}, Shapes count: {header.Shapes.Count}")
            for shape in header.Shapes:
                print(f"   Shape name: {shape.Name}")
                
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
