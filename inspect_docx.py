from docx import Document
import sys

doc_path = "C:\\Users\\Suganth\\OneDrive\\Desktop\\ml project\\CareerForge_PBL_Report_CS3505.docx"
doc = Document(doc_path)
print(f"Number of sections: {len(doc.sections)}")

for i, section in enumerate(doc.sections):
    print(f"Section {i}:")
    try:
        if section.first_page_header and section.first_page_header.part:
            print(f"  First page header: {'siragu' in section.first_page_header.part.blob.decode('utf-8', errors='ignore').lower()}")
    except: pass
    try:
        if section.header and section.header.part:
            print(f"  Primary header: {'siragu' in section.header.part.blob.decode('utf-8', errors='ignore').lower()}")
    except: pass
