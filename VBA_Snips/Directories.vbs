
'----------------------------------------------------------------------------------------
' SPECIFY FILE PATH IN THE MACRO
'----------------------------------------------------------------------------------------
Dim Foldername As String
Foldername = "\\websiteaddress\parent\child"


'----------------------------------------------------------------------------------------
' SPECIFY FILE PATH BASED ON CELL REFERENCE
'----------------------------------------------------------------------------------------
RDPath1 = Worksheets("MacroVariables").Range("B2").Value


'----------------------------------------------------------------------------------------
' OPEN A FOLDER CONTAINING THE DOCUMENT YOU ARE CURRENTLY WORKING IN---------------------
' (so you don't need to specify path here)
'----------------------------------------------------------------------------------------
Dim PathCrnt As String
PathCrnt = Application.ActiveWorkbook.Path


'----------------------------------------------------------------------------------------
' OPEN A FOLDER AND LET USER CHOSE WHICH FILE TO OPEN------------------------------------
' doesn't apply to SP dirs
'----------------------------------------------------------------------------------------

Sub OpenFileAtPath()
    ChDrive "C"
    ChDir "C:\pathparent\{pathchildfolder1}\{pathchildfolder2}"
    Application.Dialogs(xlDialogOpen).Show
End Sub

    Dim wkb1 As Workbook
    Set wkb1 = ActiveWorkbook
	'do other stuff
   
    wkb1.Activate
    Application.DisplayAlerts = False    'so not asked to save or keep data on clipboard
    ActiveWindow.Close

'----------------------------------------------------------------------------------------
' CREATE NEW DIRECTORY USING VALUES INPUT INTO CELLS-------------------------------------
'----------------------------------------------------------------------------------------
Sub Macro3()

Dim username As String
Dim section As String

username = Worksheets("Renaming Form").Range("E11").Value  'points to cells with variable inputs
section = Worksheets("Renaming Form").Range("C20").Value   'points to cells with variable inputs

'If a folder already exists, can't create new one so you get an error.  This skips the error
On Error Resume Next

'MkDri is a function to make directory
'Once you made the initial folder, you can make subfolders by changing the directory: ChDir
'This creates a new folder in the parent folder
'Note: the variables are used here to set the path
MkDir "C:\Documents and Settings\" & username & "\desktop\Engage Files to be Renamed"
    ChDir "C:\Documents and Settings\" & username & "\desktop\Engage Files to be Renamed"
    MkDir "C:\Documents and Settings\" & username & "\desktop\Engage Files to be Renamed\" & section
    'Once its created, change active dir or spreadsheet won't let go of the 
    'folder with out having to close the spreadsheet out
    ChDir "C:\"

End Sub
