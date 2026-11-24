import win32com.client
import os

doc_path = r"C:\Users\Suganth\OneDrive\Desktop\ml project\CareerForge_PBL_Report_CS3505.docx"
word = win32com.client.Dispatch("Word.Application")
word.Visible = False

try:
    doc = word.Documents.Open(doc_path)
    
    print("Tables count:", doc.Tables.Count)
    for i in range(1, doc.Tables.Count + 1):
        table = doc.Tables(i)
        print(f"Table {i} rows: {table.Rows.Count}")
        print(f"Text in R1C1: {table.Cell(1,1).Range.Text[:30]}")

    print("\nShapes count:", doc.Shapes.Count)
    for i in range(1, doc.Shapes.Count + 1):
        shape = doc.Shapes(i)
        print(f"Shape {i}: name={shape.Name}, type={shape.Type}")
        if shape.Type == 17: # msoTextBox
            print(f"Text: {shape.TextFrame.TextRange.Text[:30]}")

    doc.Close(False)
except Exception as e:
    print(e)
finally:
    word.Quit()
