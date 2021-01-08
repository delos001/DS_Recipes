
' TO OPEN AN OUTLOOK EMAIL TEMPLATE

Dim myolapp as Object
Dim my item as Object

Set myolapp = CreateObject ("Outlook.Application")
Myolapp.Session.Logon

Set myitem = myolapp.CreateItemFromTemplate ("type file path here")
