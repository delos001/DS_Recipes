

'----------------------------------------------------------------------------------------
' COPY FORMULA OR RANGE OF FORMULAS FROM ONE WORKSHEET TO ANOTHER
'note: Sheet2 is destination worksheet
'----------------------------------------------------------------------------------------
With Sheets("Sheet2")
 .Range("b1:D1").Formula = Worksheets("Sheet1").Range("b1:D1").Formula
End With
