' RUN MULTIPLE MACROS-------------------------------------------

 Application.Run "Book1!Macro1"
 Application.Run "Book1!Macro2



' NO SCREEN UPDATING--------------------------------------------
Application.ScreenUpdating = False


' STOP POPUPS WINDOWS/NOTIFICATIONS-----------------------------
Application.DisplayAlerts = False


' CHANGE CALCULATIONS FROM MANUAL TO AUTOMATIC------------------
Application.Calculation = xlAutomatic
Application.Calculation = xlManual


