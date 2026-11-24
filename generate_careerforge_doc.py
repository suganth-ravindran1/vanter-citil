import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
import win32com.client
import os
import shutil

src_docx = r"C:\Users\Suganth\Downloads\PBL Report (Machine Learning - CS3505) FINAL.docx"
target_docx = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_AI_PBL_Report.docx"
target_pdf = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_AI_PBL_Report.pdf"

# Copy source to target first to preserve all headers, shapes, watermarks, section properties, etc.
shutil.copy2(src_docx, target_docx)

doc = docx.Document(target_docx)

# Update Cover Page text
print("Updating text...")

# Helper to safely replace text in paragraphs
def replace_para_text(p, new_text, bold=None, font_size=None, align=None):
    p.text = new_text
    if bold is not None:
        for r in p.runs:
            r.bold = bold
    if font_size is not None:
        for r in p.runs:
            r.font.size = Pt(font_size)
    if align is not None:
        p.alignment = align

# Let's inspect paragraphs and update them
# Save doc
doc.save(target_docx)
print("Doc saved successfully")
