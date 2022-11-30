'In this script:
'select cells, select rows, select columns

'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'SELECT CELLS
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------
' SELECT ALL ADJACENT CELLS
'----------------------------------------------------------------------------------------
ActiveCell.CurrentRegion.Select


'----------------------------------------------------------------------------------------
' SELECT ALL CELLS (shortcut keys = ctl+sht+end)
' note: This doesn't always work if filters are applied and more cells are selected than
'    are supposed to be
'----------------------------------------------------------------------------------------
Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select


'----------------------------------------------------------------------------------------
' SELECT ALL CELLS (shortcut keys = ctl+sht+end)
'This helps get around the problem that occurs when you use the shortcut keys (ctl+shift+end) 
'   to select data after filters have been applied or duplicates removed in which excel 
'   selects more than it is supposed to.
'----------------------------------------------------------------------------------------
Dim LRA As Long
    LRA = Range("A" & Rows.count).End(xlUp).Row
Range("A1:A" & LRA).Select
Range(Selection, Selection.End(xlToRight)).Select


'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'SELECT ROWS
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------
' GO TO LAST ROW OF A SHEET
'----------------------------------------------------------------------------------------
Dim LR As Long
LR = ActiveSheet.UsedRange.Rows.Count
Range("A" & LR + 1).Select
ActiveSheet.Paste


'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'SELECT COLUMNS
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------

'----------------------------------------------------------------------------------------
'SELECT LAST COLUMNS
'----------------------------------------------------------------------------------------
LC1 = ActiveSheet.Cells(1, Columns.Count).End(xlToLeft).Column
LCRange = ActiveSheet.UsedRange.SpecialCells(xlLastCell).Column

'----------------------------------------------------------------------------------------
' SELECT ALL DATA IN A COLUMN
'becareful using this for columns as it looks to the adjacent cell to know when to stop.  
'If the adjacent cells is blank, it might not go to bottom row before selecting the data.
'----------------------------------------------------------------------------------------
Range("A1").Select
Range(Selection, Selection.End(xlDown)).Select


'----------------------------------------------------------------------------------------
' SELECT CERTAIN COLUMNS AND PASTE TO DIFFERENT WORKBOOK
'----------------------------------------------------------------------------------------
Set head = Workbooks("PCCHeadcount.xlsx").Worksheets(2).Range("A1").CurrentRegion
  Set head = head.Rows("2:" & head.Rows.Count)
  Set headselect = Application.Union(head.Columns("K:M"), _
                                      head.Columns("Q:Q"), _
                                      head.Columns("Z:AA"), _
                                     head.Columns("AG:AH"), _
                                      head.Columns("BG:BI"))

  Set headpaste = Workbooks("PCC_Directory.xlsb").Worksheets("PCCHeadcount").Range("A2")
  Set headpaste = headpaste.Rows("2:" & headpaste.Rows.Count)
  Set headdel = headpaste.CurrentRegion
  Set headdel = headdel.Rows("2:" & headdel.Rows.Count)







