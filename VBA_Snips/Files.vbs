

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
