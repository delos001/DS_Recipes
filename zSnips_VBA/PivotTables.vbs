'This script contains:
'refresh pivot tables, update pivot table source

'----------------------------------------------------------------------------------------
'REFRESH ALL PIVOT TABLES IN ONE WORKBOOK
'----------------------------------------------------------------------------------------
ActiveWorkbook.RefreshAll


'----------------------------------------------------------------------------------------
'REFRESH EACH PIVOT TABLE IN A WORKSHEET
'----------------------------------------------------------------------------------------
Dim iP As Integer

For iP = 1 To ActiveSheet.PivotTables.Count
    ActiveSheet.PivotTables(iP).RefreshTable
Next



'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'UPDATE PIVOT TABLE SOURCE
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------


'----------------------------------------------------------------------------------------
'UPDATE SOURCE FOR 1 PIVOT TABLE
'----------------------------------------------------------------------------------------
Dim LRaSheet1 As Long
Dim RngSheet1 As Range    'will be current region of sheet1 Pivot table

LRaSheet1 = Sheets("Sheet1").Range("A" & Rows.Count).End(xlUp).Row
Set RngSheet1 =Worksheets("Sheet1").Range("A1:Q" & LRaSheet1)

With Sheets("PIVOT").PivotTables(1).PivotCache
        .SourceData = RngSheet1.Address(True, True, xlR1C1, True)
        .Refresh
End With

'----------------------------------------------------------------------------------------
'REFRESH SOURCE OF ALL PIVOT TABLES ON A WORKSHEET
'----------------------------------------------------------------------------------------
Dim LastCell As Range
Dim iP as integer

Sheets("SourceSheet").Activate
Set LastCell = ActiveSheet.Cells.SpecialCells(xlCellTypeLastCell)

Sheets("PIVOT1").Select
    For iP = 1 To ActiveSheet.PivotTables.Count
    ActiveSheet.PivotTables(iP).ChangePivotCache ActiveWorkbook. _
    PivotCaches.Create(SourceType:=xlDatabase, SourceData:= _
    "SourceSheet!R1C1:R" & LastCell.Row & "C50" _
    , Version:=xlPivotTableVersion12)
    Next

    For iP = 1 To ActiveSheet.PivotTables.Count
        ActiveSheet.PivotTables(iP).RefreshTable
        ActiveSheet.PivotTables(iP).ClearAllFilters
        ActiveSheet.PivotTables(iP).RefreshTable
ActiveSheet.PivotTables(iP).PivotFields("Region").AutoSort xlAscending, "Region"
    Next





