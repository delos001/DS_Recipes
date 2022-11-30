

'----------------------------------------------------------------------------------------
' FILL DOWN TO BOTTOM CELL OF COLUMN
'----------------------------------------------------------------------------------------
Dim Lastrow As Long
Lastrow = Range("A" & Rows.Count).End(xlUp).Row
Range("B2:AB2").AutoFill Destination:=Range("B2:AB" & Lastrow)
