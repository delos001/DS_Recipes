## Resources:
- https://kevin.deldycke.com/2008/07/python-ultimate-regular-expression-to-catch-html-tags/
---

#### From Corey Shafers github: 
[https://github.com/CoreyMSchafer/code_snippets/blob/master/Python-Regular-Expressions/snippets.txt]


```
- Character matches
.       - Matches any Character Except New Line
\d      - Digit (0-9)
\D      - Not a Digit (0-9)
\w      - Word Character (a-z, A-Z, 0-9, _)
\W      - Not a Word Character
\s      - Whitespace (space, tab, newline)
\S      - Not Whitespace (space, tab, newline)

- Anchors: invisible spaces before or after character of interest
\b      - Word Boundary (white space or non-alpha numeric character)
\B      - Not a Word Boundary
^       - Beginning of a String
$       - End of a String

[]      - Matches Characters in brackets
[^ ]    - Matches Characters NOT in brackets
|       - Either Or
( )     - Group

Quantifiers:
*       - 0 or More
+       - 1 or More
?       - 0 or One
{3}     - Exact Number
{3,4}   - Range of Numbers (Minimum, Maximum)
```
