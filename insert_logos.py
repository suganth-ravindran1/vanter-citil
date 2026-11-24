from docx import Document
from docx.shared import Inches

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix3.docx"
doc = Document(doc_path)

cit_logo_path = r"C:\freemind mobile app\temp_pbl_final_extracted\word\media\image3.png"
anna_logo_path = r"C:\freemind mobile app\temp_pbl_final_extracted\word\media\image2.png"

# Find insertion points
insert_cit_idx = -1
insert_anna_idx = -1

for i, p in enumerate(doc.paragraphs[:15]):
    txt = p.text.strip()
    if "COMPUTER SCIENCE AND ENGINEERING" in txt:
        insert_cit_idx = i + 1
    if "CHENNAI INSTITUTE OF TECHNOLOGY, CHENNAI" in txt:
        insert_anna_idx = i + 1

if insert_anna_idx != -1:
    # Insert Anna Univ logo
    run = doc.paragraphs[insert_anna_idx].add_run()
    run.add_picture(anna_logo_path, width=Inches(1.2))

if insert_cit_idx != -1:
    # Insert CIT logo
    run = doc.paragraphs[insert_cit_idx].add_run()
    run.add_picture(cit_logo_path, width=Inches(2.5))
    
doc.save(r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505_Fix4.docx")
print("Done")
