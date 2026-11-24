import docx

doc = docx.Document(r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx")
print("=== TABLES ===")
for t_idx, table in enumerate(doc.tables):
    print(f"\nTable {t_idx} (rows={len(table.rows)}, cols={len(table.columns)}):")
    for r_idx, row in enumerate(table.rows[:4]):
        cells_text = [cell.text.replace('\n', ' ').strip() for cell in row.cells]
        print(f"  R{r_idx}: {cells_text}")
