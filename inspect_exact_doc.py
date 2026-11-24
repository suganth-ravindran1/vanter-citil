import docx

doc = docx.Document(r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx")

with open("full_pbl_inspection.txt", "w", encoding="utf-8") as f:
    for i, p in enumerate(doc.paragraphs):
        f.write(f"P{i:03d} | Align: {p.alignment} | Style: {p.style.name} | Text: {p.text}\n")
    
    for t_idx, t in enumerate(doc.tables):
        f.write(f"\n--- TABLE {t_idx} (rows={len(t.rows)}, cols={len(t.columns)}) ---\n")
        for r_idx, r in enumerate(t.rows):
            cells = [c.text.replace('\n', ' ') for c in r.cells]
            f.write(f"  R{r_idx}: {cells}\n")

print("Inspection completed, wrote full_pbl_inspection.txt")
