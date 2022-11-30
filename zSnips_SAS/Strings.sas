
/*-------------------------------------------------------------------------------------
COMPRESS
-------------------------------------------------------------------------------------*/

/* 
gets rid of unwanted spaces like the space before the "c" in cat and the space before 
and after the &
result is cat&dog
*/

a=" cat & dog";
x=compress(a);


/*-------------------------------------------------------------------------------------
STRINGS / SUBSTRING
-------------------------------------------------------------------------------------*/

/* picks out string based on specified numbers
it starts at the second character and gets 3 (including the starting character) */

a="(919)734-6281";
x=substr(a,2,3);  /* result is 916*/

/* gets uppercase of a, then gets the 1st character and only 1 character */
a="Delosh"
x=substr(upcase(a),1,1)  /* result: D */


/*-------------------------------------------------------------------------------------
CASE
-------------------------------------------------------------------------------------*/

/* makes all letters upper case result: MYCAT */
a="myCat";
x=upcase(a);

/* propcase capitalizes the first letter of the data, result="Mycat" */
a="MyCat";
x=propcase(a);


