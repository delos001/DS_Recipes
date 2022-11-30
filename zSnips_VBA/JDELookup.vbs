

Function JDELookup(ByVal lookupValue As String, ByVal lookupArray As Range)


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Juxtaposed Discrete Element Lookup
'
' this is designed for use with individual's names that may be in different
' formats or layouts, ie: FName LName, vs. LName,FName MInitial
'
' the function has the following input pattern:
'        JDelookup(lookupValue, lookupArray)
'
' lookupValue = is the cell that you want to find a match for
' lookupArray = the range (column) in which you want to search for the lookupValue
'
' ex: if the name of the person is in A2 and the list of names you want to look
' in is in Sheet2, column B, then the formula you would enter is:
'           JDELookup(A2,Sheet2!B:B)
'
' It would be prudent to periodically QC the results of this formula to make
' sure no new unique names or name layouts have caused this function to require
' additional programming to include these cases.  You should also review for
' new separators such as: (-, :, ., ', etc) that may need to be considered in the
' programming.
'
' FINALLY: depending on how many rows you have in each table, this function could
' take some time to run.  To improve speed, consider coupling this formula with
' index match.  Index match is much faster as it only has to look for exact values.
' Therefore, running index match first will decrease the number of cells in your
' table that need to be checked using JDELookup.  An example may look like this:
'    =iferror(index(Sheet2!B:B,match(a2,Sheet2!B:B),0),1),JDELookup(A2,Sheet2!B:B))
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Dim arrCell As Range 'each cell in the lookupArray
Dim lookupCell As String ' value of ArrCell
Dim LRarray As Long 'last row in the lookupArray
Dim strLen1 As Integer 'length of string in cell from left table
Dim strLen2 As Integer 'length of string in cell from right table
Dim replLen1 As Integer 'length of string in cell from left table after formatting the string by replacing commas and spaces with single space
Dim replLen2 As Integer 'length of string in cell from right table after formatting the string by replacing commas and spaces with single space
Dim spaceCnt1 As Integer 'number of space found in the formatted string of cell in left table
Dim spaceCnt2 As Integer 'number of space found in the formatted string of cell in right table
Dim deCnt1 As Integer 'discrete element count: counts the number of discrete elements in the cell from left table separated by spaces
Dim deCnt2 As Integer 'discrete element count: counts the number of discrete elements in the cell from right table separated by spaces
Dim deString1() As String 'the string of each discrete element from the left table
Dim deString2() As String 'the string of each discrete element from the right table
Dim imax As Single 'the highest count of matches between the two strings
Dim ieval As Single 'the count of matches of the two strings currently being evaluated
Dim delValue As String 'the value of the sucessful lookup

lookupValue = LCase(Application.Trim(Replace(Replace(Replace(lookupValue, ",", " "), " ", " "), " ", " ")))
strLen1 = Len(lookupValue)
replLen1 = Len(Replace(lookupValue, " ", ""))
spaceCnt1 = strLen1 - replLen1
deCnt1 = spaceCnt1 + 1
deString1 = Split(lookupValue, " ")

LRarray = lookupArray.Rows.Count
If VarType(lookupArray.Cells(LRarray, 1).Value) = vbEmpty Then
    LRarray = lookupArray.Cells(LRarray, 1).End(xlUp).Row
End If

imax = 0
For Each arrCell In Range(lookupArray.Cells(1, 1), lookupArray.Cells(LRarray, 1))
    lookupCell = LCase(Application.Trim(Replace(Replace(Replace(arrCell.Value, ",", " "), " ", " "), " ", " ")))
    strLen2 = Len(lookupCell)
    replLen2 = Len(Replace(lookupCell, " ", ""))
    spaceCnt2 = strLen2 - replLen2
    deCnt2 = spaceCnt2 + 1
    deString2 = Split(lookupCell, " ")
    ieval = 0

    If lookupValue <> lookupCell Then
        If InStr(1, lookupCell, deString1(0)) Then
            For spaceCnt1 = 0 To UBound(deString1)
                For spaceCnt2 = 0 To UBound(deString2)
                    If deString1(spaceCnt1) = deString2(spaceCnt2) Then
                        If Len(deString1(spaceCnt1)) = 1 And delCnt1 > 2 Then
                            ieval = ieval + 0.1
                        Else
                            ieval = ieval + 1
                        End If
                    End If
                Next
            Next

            If ieval > imax Then
                imax = ieval
                delValue = arrCell.Value
            End If
        End If
    Else
        imax = deCnt1
        delValue = arrCell.Value
        Exit For
    End If
Next arrCell
    
If imax < 1.1 Or (imax < 2 And (deCnt1 = 2 Or deCnt1 > 4)) Then
    JDELookup = CVErr(xlErrNA)
Else
    JDELookup = delValue
End If


End Function

