Private Sub Worksheet_SelectionChange(ByVal Target As Range)

    Dim LR As Long
    LR = Range("A" & Rows.Count).End(xlUp).Row
    Dim LC As Long
    LC = ActiveSheet.Cells(1, Columns.Count).End(xlToLeft).Column
    
   If Not Intersect(ActiveCell, Range("A2" & LC & LR)) Is Nothing Then
      Range(Cells(1, 1), Cells(LR, LC)).Interior.ColorIndex = xlNone
        Range(Cells(ActiveCell.Row, 1), Cells(ActiveCell.Row, LC)).Interior.ColorIndex = 4
    End If
