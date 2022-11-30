
'----------------------------------------------------------------------------------------
' RENAME A TABLE (when its only object on the page)
'----------------------------------------------------------------------------------------

With ActiveSheet
    .ListObjects(1).Name = "MyTableName"
End With
