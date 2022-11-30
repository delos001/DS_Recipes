

'----------------------------------------------------------------------------------------
' FORMAT TEXT (number format)
'----------------------------------------------------------------------------------------
Sheets("Sheet1").Select
Columns("A:A").Select
Selection.NumberFormat = "@"


'----------------------------------------------------------------------------------------
' CONDITIONAL FORMAT 
'----------------------------------------------------------------------------------------
Range("A3:L100,N3:V100").Select
Selection.FormatConditions.Add Type:=xlExpression, Formula1:= _
    "=IF(RIGHT($A3,5)=""Total"", TRUE, FALSE)"
Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
With Selection.FormatConditions(1).Font
    .Bold = True
End With
'record macro to get pattern, theme, shade if you want
With Selection.FormatConditions(1).Interior
    .PatternColorIndex = xlAutomatic
    .ThemeColor = xlThemeColorDark1
    .TintAndShade = -0.249946592608417
End With


'----------------------------------------------------------------------------------------
' FORMAT EVERY OTHER COLUMN (example)
'----------------------------------------------------------------------------------------
Dim x As Integer
Dim LRa As Long
    LRa = Range("A" & Rows.Count).End(xlUp).Row
Dim LCol As Long
    LCol = Cells(LRa, Columns.Count).End(xlToLeft).Column
       
For x = 1 To LCol Step 2
ActiveSheet.UsedRange.Columns(x).Select
        With Selection.Interior
            .Pattern = xlSolid
            .PatternColorIndex = xlAutomatic
            .ThemeColor = xlThemeColorDark1
            .TintAndShade = -0.249977111117893
            .PatternTintAndShade = 0
        End With
Next x
