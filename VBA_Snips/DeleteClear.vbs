'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
' CLEAR
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------
' CLEAR ALL (includes values, formats, etc)
'----------------------------------------------------------------------------------------
Selection.Clear


'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
' DELETE
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------
DELETE ENTIRE ROW
'----------------------------------------------------------------------------------------
Range("A2").Activate
Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select  'selects all cells to bottom row
Selection.EntireRow.Delete


'----------------------------------------------------------------------------------------
DELETE CELLS WITH SPECIFIED VALUE
'----------------------------------------------------------------------------------------
Dim rng As Range, cell As Range, del As Range
 
Range("A1").Select
LR = ActiveSheet.UsedRange.Rows.Count
 
Set rng = Intersect(Range("A1:C" & LR), ActiveSheet.UsedRange)
For Each cell In rng
If (cell.Value) = "Closed" _
Then
If del Is Nothing Then
Set del = cell
Else: Set del = Union(del, cell)
End If
End If
Next cell
On Error Resume Next
del.EntireRow.Delete


'----------------------------------------------------------------------------------------
DELETE ROWS THAT DONT CONTAIN A SPECIFIED VALUE
'----------------------------------------------------------------------------------------
Dim rng As Range, cell As Range, del As Range

  Range("I1").Select
  LRi = ActiveSheet.UsedRange.Rows.Count

  Set rng = Intersect(Range("I2:I" & LRi), ActiveSheet.UsedRange)
  For Each cell In rng
      If (cell.Value) <> "Open" _
      Then
          If del Is Nothing Then
              Set del = cell
              Else: Set del = Union(del, cell)
          End If
      End If
  Next cell
  On Error Resume Next
  del.EntireRow.Delete
    
    
'----------------------------------------------------------------------------------------
DELETE ROWS THAT CONTAIN DATE PRIOR TO SPECIFIED DATE
'----------------------------------------------------------------------------------------
Dim rng As Range, cell As Range, del As Range, tDate As String
tDate = Date

Range("C1").Select
LRc = ActiveSheet.UsedRange.Rows.Count

Set rng = Intersect(Range("C2:C" & LRc), ActiveSheet.UsedRange)
For Each cell In rng
    If DateDiff("d", cell.Value, tDate) >  42 _
    Then
        If del Is Nothing Then
            Set del = cell
            Else: Set del = Union(del, cell)
        End If
    End If
Next cell
  On Error Resume Next
del.EntireRow.Delete


'----------------------------------------------------------------------------------------
DELETE ROWS ABOVE HEADER
'----------------------------------------------------------------------------------------
Dim hRow As Range  'set variable to delete any rows above header
If Range("D1") = "" Then
    With Columns("D")
        .Find(what:="*", after:=.Cells(1, 1), LookIn:=xlFormulas).Activate
    End With
Set hRow = ActiveCell
Range("D1", hRow).Select
Selection.SpecialCells(xlCellTypeBlanks).EntireRow.Delete
Else
End If


'----------------------------------------------------------------------------------------
DELETE ROWS WITH MULTIPLE VALUES LOCATED IN RANGE ELSEWHERE
'----------------------------------------------------------------------------------------
Dim rng1 As Range
Dim cell1 As Range
Dim del As Range
Dim rng2 As Range
Dim LRg1 As Long
Dim LRa2 As Long

Worksheets("Macro").Range("G1").Select

LRg1 = Worksheets("Macro").Range("G" & Rows.Count).End(xlUp).Row
LRa2 = Worksheets("Names").Range("A" & Rows.Count).End(xlUp).Row
Set rng1 = Worksheets("Macro").Range("G2:G" & LRg1)
Set rng2 = Worksheets("Names").Range("A2:A" & LRa2)

For Each cell1 In rng1
 
    With rng2
        Set Rng = .Find(What:=cell1, _
                        After:=.Cells(.Cells.Count), _
                        LookIn:=xlValues, _
                        LookAt:=xlWhole, _
                        SearchOrder:=xlByRows, _
                        SearchDirection:=xlNext, _
                        MatchCase:=False)
        If Rng Is Nothing Then
            If del Is Nothing Then
                Set del = cell1
                Else: Set del = Union(del, cell1)
            End If
        End If
    End With
    
Next cell1
On Error Resume Next
del.EntireRow.Delete
