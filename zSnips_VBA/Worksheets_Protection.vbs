<<<<<<< HEAD

'----------------------------------------------------------------------------------------
' PROTECT OR UNPROTECT SHEETS
'----------------------------------------------------------------------------------------
ActiveSheet.Protect Password:="test"
ActiveSheet.Protect DrawingObjects:=True, Contents:=True, Scenarios:=True   'This protects sheet
	
ActiveSheet.Unprotect Password:="test"                                      'This unprotects sheet
ActiveSheet.Unprotect


'----------------------------------------------------------------------------------------
'UNPROTECT A PASSWOR PROTECTED SHEET WITHOUT PASSWORD---------
'Put this code in the sheets VBA page and run it
'----------------------------------------------------------------------------------------

Sub PasswordBreaker()
    'Breaks worksheet password protection.
    Dim i As Integer, j As Integer, k As Integer
    Dim l As Integer, m As Integer, n As Integer
    Dim i1 As Integer, i2 As Integer, i3 As Integer
    Dim i4 As Integer, i5 As Integer, i6 As Integer
    On Error Resume Next
    For i = 65 To 66: For j = 65 To 66: For k = 65 To 66
    For l = 65 To 66: For m = 65 To 66: For i1 = 65 To 66
    For i2 = 65 To 66: For i3 = 65 To 66: For i4 = 65 To 66
    For i5 = 65 To 66: For i6 = 65 To 66: For n = 32 To 126
    ActiveSheet.Unprotect Chr(i) & Chr(j) & Chr(k) & _
        Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & _
        Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
    If ActiveSheet.ProtectContents = False Then
        MsgBox "One usable password is " & Chr(i) & Chr(j) & _
            Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & _
            Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
         Exit Sub
    End If
    Next: Next: Next: Next: Next: Next
    Next: Next: Next: Next: Next: Next
End Sub
=======

'----------------------------------------------------------------------------------------
' PROTECT OR UNPROTECT SHEETS
'----------------------------------------------------------------------------------------
ActiveSheet.Protect Password:="test"
ActiveSheet.Protect DrawingObjects:=True, Contents:=True, Scenarios:=True   'This protects sheet
	
ActiveSheet.Unprotect Password:="test"                                      'This unprotects sheet
ActiveSheet.Unprotect


'----------------------------------------------------------------------------------------
'UNPROTECT A PASSWOR PROTECTED SHEET WITHOUT PASSWORD---------
'Put this code in the sheets VBA page and run it
'----------------------------------------------------------------------------------------

Sub PasswordBreaker()
    'Breaks worksheet password protection.
    Dim i As Integer, j As Integer, k As Integer
    Dim l As Integer, m As Integer, n As Integer
    Dim i1 As Integer, i2 As Integer, i3 As Integer
    Dim i4 As Integer, i5 As Integer, i6 As Integer
    On Error Resume Next
    For i = 65 To 66: For j = 65 To 66: For k = 65 To 66
    For l = 65 To 66: For m = 65 To 66: For i1 = 65 To 66
    For i2 = 65 To 66: For i3 = 65 To 66: For i4 = 65 To 66
    For i5 = 65 To 66: For i6 = 65 To 66: For n = 32 To 126
    ActiveSheet.Unprotect Chr(i) & Chr(j) & Chr(k) & _
        Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & Chr(i3) & _
        Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
    If ActiveSheet.ProtectContents = False Then
        MsgBox "One usable password is " & Chr(i) & Chr(j) & _
            Chr(k) & Chr(l) & Chr(m) & Chr(i1) & Chr(i2) & _
            Chr(i3) & Chr(i4) & Chr(i5) & Chr(i6) & Chr(n)
         Exit Sub
    End If
    Next: Next: Next: Next: Next: Next
    Next: Next: Next: Next: Next: Next
End Sub




'----------------------------------------------------------------------------------------
'Contains multiple unlock mechanisms (sheet, workbook, etc)---------
'Put this code in the sheets VBA project and run
'----------------------------------------------------------------------------------------
' modUnlockRoutines
'
' Module provides Excel workbook and sheet unlock routines. The algorithm
' relies on a backdoor password that can be 1 to 9 characters long where each
' character is either an "A" or "B" except the last which can be any character
' from ASCII code 32 to 255.
'
' Implemented as a regular module for use with any Excel VBA project.
' Dependencies:
' None
' © 2007 Kevin M. Jones

Option Explicit
Private Sub DisplayStatus(ByVal PasswordsTried As Long)
' Display the status in the Excel status bar.
'
' Syntax
'
' DisplayStatus(PasswordsTried)
'
' PasswordsTried - The number of passwords tried thus far.
Static LastStatus As String
LastStatus = Format(PasswordsTried / 57120, "0%") & " of possible passwords tried."
If Application.StatusBar <> LastStatus Then
Application.StatusBar = LastStatus
DoEvents
End If
End Sub

Private Function TrySheetPasswordSize(ByVal Size As Long, ByRef PasswordsTried As Long, ByRef Password As String, Optional ByVal Base As String) As Boolean
' Try unlocking the sheet with all passwords of the specified size.
'
' TrySheetPasswordSize(Size, PasswordsTried, Password, [Base])
'
' Size - The size of the password to try.
'
' PasswordsTried - The cummulative number of passwords tried thus far.
'
' Password - The current password.
'
' Base - The base password from the calling routine.
Dim Index As Long
On Error Resume Next
If IsMissing(Base) Then Base = vbNullString
If Len(Base) < Size - 1 Then
For Index = 65 To 66
If TrySheetPasswordSize(Size, PasswordsTried, Password, Base & Chr(Index)) Then
TrySheetPasswordSize = True
Exit Function
End If
Next Index
ElseIf Len(Base) < Size Then
For Index = 32 To 255
ActiveSheet.Unprotect Base & Chr(Index)
If Not ActiveSheet.ProtectContents Then
TrySheetPasswordSize = True
Password = Base & Chr(Index)
Exit Function
End If
PasswordsTried = PasswordsTried + 1
Next Index
End If
On Error GoTo 0
DisplayStatus PasswordsTried
End Function

Private Function TryWorkbookPasswordSize(ByVal Size As Long, ByRef PasswordsTried As Long, ByRef Password As String, Optional ByVal Base As String) As Boolean
' Try unlocking the workbook with all passwords of the specified size.
'
' TryWorkbookPasswordSize(Size, PasswordsTried, Password, [Base])
'
' Size - The size of the password to try.
'
' PasswordsTried - The cummulative number of passwords tried thus far.
'
' Password - The current password.
'
' Base - The base password from the calling routine.
Dim Index As Long
On Error Resume Next
If IsMissing(Base) Then Base = vbNullString
If Len(Base) < Size - 1 Then
For Index = 65 To 66
If TryWorkbookPasswordSize(Size, PasswordsTried, Password, Base & Chr(Index)) Then
TryWorkbookPasswordSize = True
Exit Function
End If
Next Index
ElseIf Len(Base) < Size Then
For Index = 32 To 255
ActiveWorkbook.Unprotect Base & Chr(Index)
If Not ActiveWorkbook.ProtectStructure And Not ActiveWorkbook.ProtectWindows Then
TryWorkbookPasswordSize = True
Password = Base & Chr(Index)
Exit Function
End If
PasswordsTried = PasswordsTried + 1
Next Index
End If
On Error GoTo 0
DisplayStatus PasswordsTried
End Function

Public Sub UnlockSheet()
' Unlock the active sheet using a backdoor Excel provides where an alternate
' password is created that is more limited.
Dim PasswordSize As Variant
Dim PasswordsTried As Long
Dim Password As String
PasswordsTried = 0
If Not ActiveSheet.ProtectContents Then
MsgBox "The sheet is already unprotected."
Exit Sub
End If
On Error Resume Next
ActiveSheet.Protect ""
ActiveSheet.Unprotect ""
On Error GoTo 0
If ActiveSheet.ProtectContents Then
For Each PasswordSize In Array(5, 4, 6, 7, 8, 3, 2, 1)
If TrySheetPasswordSize(PasswordSize, PasswordsTried, Password) Then Exit For
Next PasswordSize
End If
If Not ActiveSheet.ProtectContents Then
MsgBox "The sheet " & ActiveSheet.Name & " has been unprotected with password '" & Password & "'."
End If
Application.StatusBar = False
End Sub

Public Sub UnlockWorkbook()
' Unlock the active workbook using a backdoor Excel provides where an alternate
' password is created that is more limited.
   Dim PasswordSize As Variant
   Dim PasswordsTried As Long
   Dim Password As String
   PasswordsTried = 0
   If Not ActiveWorkbook.ProtectStructure And Not ActiveWorkbook.ProtectWindows Then
     MsgBox "The workbook is already unprotected."
     Exit Sub
   End If
   On Error Resume Next
   ActiveWorkbook.Unprotect vbNullString
   On Error GoTo 0
   If ActiveWorkbook.ProtectStructure Or ActiveWorkbook.ProtectWindows Then
     For Each PasswordSize In Array(5, 4, 6, 7, 8, 3, 2, 1)
         If TryWorkbookPasswordSize(PasswordSize, PasswordsTried, Password) Then Exit For
     Next PasswordSize
   End If
   If Not ActiveWorkbook.ProtectStructure And Not ActiveWorkbook.ProtectWindows Then
     MsgBox "The workbook " & ActiveWorkbook.Name & " has been unprotected with password '" & Password & "'."
   End If
   Application.StatusBar = False
End Sub
>>>>>>> e273c708f0679ce5351676df61e954d38e6812a9
