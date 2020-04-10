

'----------------------------------------------------------------------------------------
' REMOVE ALL FILTERS
'----------------------------------------------------------------------------------------
ActiveSheet.ShowAllData


'----------------------------------------------------------------------------------------
' FILTER FOR UNIQUE VALUES
'----------------------------------------------------------------------------------------
Selection.AutoFilter
Columns("G:G").AdvancedFilter Action:=xlFilterInPlace, Unique:=True



'----------------------------------------------------------------------------------------
' FILTER MULTIPLE PAGES USING CELL VALUES AS FILTER CRITERIA
'----------------------------------------------------------------------------------------
Sheets("TIMI Memo 121a").Select
Columns("E:E").Select
ActiveSheet.Range("$A$1:$K$7").AutoFilter Field:=2,  'AutoFilter Field is col numb to filter
  Criteria1=Worksheets("Sheet1").Range("A1").Value
