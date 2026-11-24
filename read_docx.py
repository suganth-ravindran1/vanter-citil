from docx import Document
doc_path = "C:\\Users\\Suganth\\OneDrive\\Desktop\\ml project\\CareerForge_PBL_Report_CS3505.docx"
doc = Document(doc_path)
for i, p in enumerate(doc.paragraphs[:30]):
    print(f"P{i}: [{p.style.name}] {p.text.strip()[:60]}")
