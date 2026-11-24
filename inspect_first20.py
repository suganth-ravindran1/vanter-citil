import win32com.client
doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False
try:
    doc = word.Documents.Open(doc_path)
    for i in range(20):
        try:
            print(f"P{i}: '{doc.Paragraphs(i+1).Range.Text.strip()}'")
        except:
            pass
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
