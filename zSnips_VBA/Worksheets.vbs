
'----------------------------------------------------------------------------------------
' HIDE OR UNHIDE SHEETS
'----------------------------------------------------------------------------------------
Sheets("Sheet1").Select
ActiveWindow.SelectedSheets.Visible = False

ActiveWindow.SelectedSheets.Visible = True
  
  
  
'----------------------------------------------------------------------------------------
' HIDE WORKSHEET WHEN IT IS INACTIVE
'---------------------------------------------------------------------------------------- 
Private Sub Worksheet_Deactivate()
    Me.Visible = xlHidden
End Sub




