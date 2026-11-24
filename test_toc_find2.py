import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    in_toc = False
    for p in doc.Paragraphs:
        txt = p.Range.Text
        if "TABLE OF CONTENTS" in txt:
            in_toc = True
            continue
        if in_toc and "BONAFIDE" in txt:
            print("Before:", repr(txt))
            rng = p.Range
            rng.Find.ClearFormatting()
            rng.Find.Replacement.ClearFormatting()
            rng.Find.MatchWildcards = True
            rng.Find.Execute(FindText=r" \.[ \.]{1,}", ReplaceWith="\t", Replace=2)
            print("After:", repr(p.Range.Text))
            break
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
