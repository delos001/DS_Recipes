'In this Snip: 
'Open files, save files, rename files

'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'  OPENING FILES
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------
' OPEN BLANK WORKBOOK
'----------------------------------------------------------------------------------------
Sub Macro1()
' Macro1 Macro
    Workbooks.Add
End Sub


'----------------------------------------------------------------------------------------
' OPEN A FILE BASED ON VARIABLES
'----------------------------------------------------------------------------------------
Opening a file based on variables

Dim RDPath1 As String
Dim File1 As String

RDPath1 = Worksheets("MacroVariables").Range("B2").Value
File1 = Worksheets("MacroVariables").Range("D3").Value

  'This tells it to open the file based on the data in cell B2 and the data in cell D3.
  Workbooks.Open Filename:=RDPath1 & File1
  Windows(File1).Activate
  
  

'----------------------------------------------------------------------------------------
' OPEN FILE (BASIC) from Website
'----------------------------------------------------------------------------------------
Workbooks.Open Filename:= _
"\\websiteaddress.com\child1\child2\filename.xlsx"


'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
' SAVING FILES
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------
'SAVE COPY OF FILE
'----------------------------------------------------------------------------------------
ActiveWorkbook.SaveCopyAs FileName:="C:\Test\CopyBook.xls"


'----------------------------------------------------------------------------------------
'SAVE FILE WHERE PART OF PATH IS CONTAINED IN CELL
'----------------------------------------------------------------------------------------
Dim strPath As String
Dim strFolderPath As String

' Sheet1.Range references the cell where you input the path
strFolderPath = "C:\Documents and Settings\" & _
    Sheet1.Range("A1").Value & "\Desktop\"

strPath = strFolderPath & "test.xlsm"     'chose file name'

ActiveWorkbook.SaveAs Filename:=strPath   'tells the macro to save it based on strPath


'----------------------------------------------------------------------------------------
'SAVE FILE USING ENVIRONMENT
'To find the directory of a user (for example to define the path to desktop), 
'you can use this and then use username as you’d normally do to define your path.

'other options: enrivon('alluserprofile', 'computername', 'homedrive', 'programfiles'
'                       'userdomain', 'username', 'userprofile')
'----------------------------------------------------------------------------------------
username = Environ("username")


'----------------------------------------------------------------------------------------
'SAVE WITH DIFFERENT EXTENSION
'File Extensions:
'51 = xlOpenXMLWorkbook (without macro's in 2007-2010, xlsx)
'52 = xlOpenXMLWorkbookMacroEnabled (with or without macro's in 2007-2010, xlsm)
'50 = xlExcel12 (Excel Binary Workbook in 2007-2010 with or without macro's, xlsb)
'56 = xlExcel8 (97-2003 format in Excel 2007-2010, xls)

'6 FileExtStr = ".csv"
'4158 FileExtStr = ".txt"
'36 FileExtStr = ".prn"
'---------------------------------------------------------------------------------------
ActiveWorkbook.SaveAs "C:\filename.xlsm", fileformat:=52 


'----------------------------------------------------------------------------------------
' SAVING FILE WITH CURRENT DATE
'----------------------------------------------------------------------------------------
ActiveWorkbook.SaveAs "C:\pathparent\filename " & Format(Date, "yyyymmdd") & ".xlsm"


'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'  RENAME FILES
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------
'  RENAME FILE NAME (basic)
'----------------------------------------------------------------------------------------
Option Explicit

Sub Rename()

Dim fileToOpen As String
Dim MyPath As String
Dim NewName As String
Dim NewFile As String


''ChDir ThisWorkbook.path

fileToOpen = Application.GetOpenFilename("All Files (*.pdf),*.pdf")

If fileToOpen <> "" Then
    MsgBox "Open " & fileToOpen

   
        NewName = Sheets(2).Range("C23")
        NewFile = MyPath & NewName

        If Dir(NewFile) <> "" Then
            MsgBox "File: """ & NewFile & """ already existing"
        Else
            Name fileToOpen As NewFile
        End If
    End If
End Sub
