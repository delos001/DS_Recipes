
'----------------------------------------------------------------------------------------
' DELETE ROWS (basic)
'----------------------------------------------------------------------------------------
Dim myColm As Range    
Set myColm = Worksheets("Contacts").Columns(3)
    
    myColm.SpecialCells(xlCellTypeBlanks).EntireRow.Delete
