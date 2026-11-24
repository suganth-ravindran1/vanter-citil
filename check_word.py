import win32com.client
import sys

try:
    word = win32com.client.Dispatch("Word.Application")
    print("Word is available!")
    word.Quit()
except Exception as e:
    print(f"Error: {e}")
