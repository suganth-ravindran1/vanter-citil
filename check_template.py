import win32com.client

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\temp_pbl_template.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False
try:
    doc = word.Documents.Open(doc_path)
    print("Tables:", doc.Tables.Count)
    for i in range(1, doc.Tables.Count + 1):
        table = doc.Tables(i)
        print(f"Table {i} rows: {table.Rows.Count}, R1C1: {table.Cell(1,1).Range.Text[:30]}")
    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
