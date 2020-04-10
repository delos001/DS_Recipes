

'----------------------------------------------------------------------------------------
'REMOVE UNWANTED OR HIDDEN SPACES IN CELLS
'You need to record this macro.  When trying to get rid of the spaces using the replace 
'function in excel, hold the ALT key and type 0160 (and any other additional characters 
'you don't want).

'In this example, I wanted to get rid of the parenthesis and everyting in between, 
'plus an html space, so I typed 0160 while holding the ALT key and then (*).  
'----------------------------------------------------------------------------------------
Columns("G:G").Select
Selection.Replace What:=" (*)", Replacement:="", LookAt:=xlPart, _
    SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
    ReplaceFormat:=False
    
    
    
    
'----------------------------------------------------------------------------------------
'REMOVE LEADING AND LAGGING SPACES
'----------------------------------------------------------------------------------------
Range("A1:W1").Select 'to get rid of leading and lagging spaces
For Each cell In ActiveSheet.UsedRange
cell.Value = Application.Clean(cell.Value)
Next
