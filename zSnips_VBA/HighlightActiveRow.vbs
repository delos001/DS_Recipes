' there are two diff methods in this recipe
' 1: uses vba only
' 2: uses less vba and uses conditional formatting and named range

'-------------------------------------------------------------------
'1
Private Sub Worksheet_SelectionChange(ByVal Target As Range)

    Dim LR As Long
    LR = Range("A" & Rows.Count).End(xlUp).Row
    Dim LC As Long
    LC = ActiveSheet.Cells(1, Columns.Count).End(xlToLeft).Column
    
   If Not Intersect(ActiveCell, Range("A2" & LC & LR)) Is Nothing Then
      Range(Cells(1, 1), Cells(LR, LC)).Interior.ColorIndex = xlNone
        Range(Cells(ActiveCell.Row, 1), Cells(ActiveCell.Row, LC)).Interior.ColorIndex = 4
    End If
End Sub

'---------------------------------------------------------------------
'2
' STEPS
' got to: formulas/define formula, Name = HighlightRow, Refers to = 1
' select all rows for columns of interest (those you want highlighted)
' after selecting, conditional format/new rule
' chose "use a formula to dtermine which cells to format"
' in "formt values where this formula is true" enter =Row(A1)=HighlightRow
' click "format" button and chose your fill color.  Hit OK
' make sure "Developer" is added to your ribbon (File/Options/CustomizeRibbon)
' Click "Developer" on ribbon
' click "Visual Basic" button
' select appropriate sheet in left pane
' in code box, change "General" to "Worksheet" and make sure "SelectionChange" is showing for right hand box
' delete default code, paste the following code below, close developer window and save sheet as macro enabled

Private Sub Worksheet_SelectionChange(ByVal Target As Range)
With ThisWorkbook.Names("HighlightRow")
.Name = "HighlightRow"
.RefersToR1C1 = "=" & ActiveCell.Row
End With
End Sub

