import win32com.client
import os

word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    for filename in ["temp_pbl_template.docx", "temp_pbl_final.docx", "CareerForge_PBL_Report_CS3505.docx"]:
        doc_path = os.path.join(r"C:\Users\Suganth\OneDrive\Desktop\ml project", filename)
        if not os.path.exists(doc_path):
            continue
        doc = word.Documents.Open(doc_path)
        print(f"--- {filename} ---")
        print(f"Sections: {doc.Sections.Count}")
        for i, section in enumerate(doc.Sections):
            for h_idx, header in enumerate(section.Headers):
                print(f" Sec {i+1} Header {h_idx+1}: Shapes={header.Shapes.Count}, InlineShapes={header.Range.InlineShapes.Count}")
                for s_idx in range(1, header.Shapes.Count + 1):
                    print(f"   Shape {s_idx}: {header.Shapes(s_idx).Name}")
        doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
