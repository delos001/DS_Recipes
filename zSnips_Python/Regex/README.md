## Resources:
- https://kevin.deldycke.com/2008/07/python-ultimate-regular-expression-to-catch-html-tags/
---

#### From: 
Corey Shafers github: [https://github.com/CoreyMSchafer/code_snippets/blob/master/Python-Regular-Expressions/snippets.txt]
PythonProgramming: https://pythonprogramming.net/regular-expressions-regex-tutorial-python-3/

```
Character matches
.       - Matches any Character Except New Line
\d      - Digit (0-9)
\D      - Not a Digit (0-9) anything but a number
\w      - Word Character (a-z, A-Z, 0-9, _): any letter
\W      - Not a Word Character: anything but a letter
\s      - Whitespace (space, tab, newline)
\S      - Not Whitespace (space, tab, newline)

Anchors: invisible spaces before or after character of interest
\b      - Word Boundary (white space or non-alpha numeric character around whole words)
\B      - Not a Word Boundary
^       - Beginning of a String
$       - End of a String

[]      - Matches Characters in brackets
[^ ]    - Matches Characters NOT in brackets
|       - Either Or
( )     - Group

Quantifiers:
*       - match 0 or more repititions
+       - mathc 1 or more repititions
?       - match 0 or one repititions

^       - match at the beginning of a string
$       - match at the end of a string

| = matches either/or. Example x|y = will match either x or y

{3}     - Exact Number
{3,4}   - Range of Numbers (Minimum, Maximum) expect 3-4 counts of digits, or "places"
{x}     - expect to see this amount of the preceding code.
{x,y}   - expect to see this x-y amounts of the precedng code
[]      - range, or "variance"


Brackets:
[]      - quant[ia]tative = will find either quantitative, or quantatative.
        ex: [a-z]   - return any lowercase letter a-z
        ex: [1-5a-qA-Z] - return all numbers 1-5, lowercase letters a-q and uppercase A-Z


Characters to REMEMBER TO ESCAPE IF USED:
. + * ? [ ] $ ^ ( ) { } | \
    ex: \. = period. must use backslash, because . normally means any character.
    
    
White Space Charts:
\n = new line
\s = space
\t = tab
\e = escape
\f = form feed
\r = carriage return
```

