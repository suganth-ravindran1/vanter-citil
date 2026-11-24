import docx

doc = docx.Document(r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx")
print("Total paragraphs:", len(doc.paragraphs))
print("Total tables:", len(doc.tables))
print("Total sections:", len(doc.sections))

with open("pbl_report_paragraphs.txt", "w", encoding="utf-8") as f:
    for i, p in enumerate(doc.paragraphs):
        f.write(f"[{i}] {p.text}\n")

print("Saved pbl_report_paragraphs.txt")
