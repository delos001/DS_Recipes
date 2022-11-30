
'----------------------------------------------------------------------------------------
' SET UP THE ADDIN BUTTON ON YOUR RIBBON
' Go to Developer and choose the tab “This Workbook” in Microsoft Excel Objects. 
' Copy/paste the code below into the open window. 
'----------------------------------------------------------------------------------------


Private Sub Workbook_Open()
Dim cbCommandBar As CommandBar
Dim cbCommandMenu As CommandBarPopup
Dim cbCommandButton As CommandBarButton     'Definitions necessary for button
Set cbCommandBar = Application.CommandBars("Worksheet Menu Bar")    'Declaration: start application command bars. 
Set cbCommandMenu = cbCommandBar.Controls.Add(Type:=msoControlPopup, Temporary:=True)   'Declaration: sub-controls in the menu of the Add In
cbCommandMenu.Caption = "Action Items Report"
cbCommandMenu.Tag = "Action Items Report"     'Name of the add in 
Set cbCommandButton = cbCommandMenu.Controls.Add(Type:=msoControlButton)    'Declaration: command button to be included in add in menu
cbCommandButton.OnAction = "Launch_VBS"       'Define the macro of that button
cbCommandButton.Caption = "Step 1: Launch the VBS script"     'Define the name of the macro
 
Set cbCommandButton = cbCommandMenu.Controls.Add(Type:=msoControlButton)
cbCommandButton.OnAction = "Run_all"
'Repetition of the command above. You can copy/paste this command as often as you need buttons
cbCommandButton.Caption = "Step 2: Run the report" 

End Sub[q9] 
