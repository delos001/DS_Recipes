## Python Basics

```
String Methods
https://docs.python.org/3.7/library/stdtypes.html#string-methods

Dictionaries
https://docs.python.org/2/library/stdtypes.html#dict

Numpy Tutorial:
https://colab.research.google.com/github/cs231n/cs231n.github.io/blob/master/python-colab.ipynb#scrollTo=0JoA4lH6L9ip
```
|Syntax|Description|
|---|---|
|# text| descriptive comment|
|''' text '''| multiline comment|
|||
|Dir()|Yields all the variables, lists, etc that are currently used|
|||
|type(object)|produces object type|
|isinstance(yourobject, datetime.datetime|true/false if object is of specified class|
|||
|object.head()|get first 5 rows
|object.shape|gives number of rows and columns|
|object.columns|gives column names|
|object.dtypes|gives you column types|
___


## Keywords in Python that cannot be assigend as variables
```
and, as, assert,break, class, continue, def, del, elif, else, except, exec, finally, for, from, global
if, import, in, is, lambda, not, or, pass, print, raise, return, try, while, with, yield
```

## Standard Definitions
|Term|Definition|
|---|---|
|Assignment| Statement that assigns a value to a variable|
|Comment| Information in a program that explains/clarifies code and no effect on the execution of the program|
|Concatenate| To join two operands end-to-end|
|Evaluate| To simplify an expression by performing the operations in order to yield a single value|
|Expression| A combination of variables, operators, and values that represents a single result value|
|Floating-point| Type that represents numbers with fractional parts|
|Floor division| The operation that divides two numbers and chops off the fraction part|
|Integer| Type that represents whole numbers|
|Keyword| Reserved word used by the compiler to parse a program|
|Numbers| (type float), and strings (type str)|
|Operand| One of the values on which an operator operates|
|Operator| Special symbol that represents a simple computation like addition, multiplication, or string concatenation|
|Rules of precedence| Set of rules governing the order in which expressions involving multiple operators and operands are evaluated|
|State diagram| A graphical representation of a set of variables and the values they refer to|
|Statement| Section of code that represents a command or action|
|String| Type that represents sequences of characters|
|Type| Category of values|
|Value| One of the basic units of data, like a number or string, that a program manipulates|
|Variable| Name that refers to a value|
---

## Version Identification
- Python:
	- Command prompt, 'python --version'
	- Anaconda prompt, 'python -V'
- Packages:
	- Python environment, 'print('matplotlib: %s' % matplotlib.__version__)'
	
---

## PIP
|Command|Description|
|---|---|
|!pip list|Get list of all packages: done within Jupyter Notebook/Lab|
|pip install package_name|install package from anaconda command prompt|

---

## Anaconda:
- in terminal: 
	- conda update conda
	- conda update anaconda
	
### JUPYTER NOTEBOOK AND LAB

Tips and Tricks:
- https://towardsdatascience.com/bringing-the-best-out-of-jupyter-notebooks-for-data-science-f0871519ca29
- https://www.kdnuggets.com/2020/01/optimize-jupyter-notebook.html

#### Operations in Anaconda Prompt
|Command|Description|
|---|---|
|jupyter notebook --notebook-dir D:/|Change the drive that opens Jupyter Notebook|
|jupyter lab --notebook-dir D:/my_works/jupyter_ipynbs|Change the drive that opens Jupyter Labs|

- If Jupyter Lab Doesn't Load
	+ paste this into Chrome browser: http://localhost:8891/lab
	+ open anacond prompt and type: jupyter notebook list
	+ copy the token (note just the token after "token=" and up to the ::) and 
	+ paste it into the token area of the web browser that opened
---
#### Operations In Notebook
|Command|Description|
|---|---|
|!python --version|show the current python version|
|os.getcwd()|Get the working directory. Note: must import os|
|%reset|Clear all variables in Jupyter environment, https://stackoverflow.com/questions/22934204/how-to-clear-variables-in-ipython|
|!pip list|show all installed packages|
---
#### Operations In Notebook (Magic Commands)
*% means command will come from a single line-line magics
*%% means command will come from the entire cell-cell magics

|Command|Description|
|---|---|
|%lsmagic|yields all the magic commands available|
|%pwd|print working directory|
|%ls|list files and folders in working directory|
|%ls-la|long list forms and files in working directory|
|%matplotlib inline|allows plots to be rendered in notebook.  May also need: <br/> import plotly.offline as py <br/> py.init_notebook_mode(connected=True)|
|%%HTML <br/> <iframe width="560" heights="315" <br/> src="https://www.youtube.com/embed/YJC6ldI3hWk" <br/> frameborder="0" allowfullscreen></iframe>|place an iframe in a notebook, ex: Youtube video|
|%%timeit|gets code runtime. ex: sqeven = (t * t for t in range(1000))|

---

#### Jupyter Notebook GitHub Rendering Workaround
```
The site nbviewer works independently of github.

Try to open that notebook that you want using nbviewer online, you don't need to install it.
Open "https://nbviewer.jupyter.org/"
Paste the link to your notebook:
    (e.g. "https://github.com/iurisegtovich/PyTherm-applied-thermodynamics/blob/master/index.ipynb") 
    
Then you get:
"http://nbviewer.jupyter.org/github.com/delos001/Python_Snips/tree/master/Regex/index.ipynb"

If some notebook rendered in nbviewer appears different from rendered in github, then append the following
to the end of the nbviewer version url to force it to rerender:
    "?flush_cache=true" 
    (e.g. http://nbviewer.jupyter.org/github.com/delos001/Python_Snips/tree/master/Regex/index.ipynb?flush_cache=true
```

---
## Anaconda Resources

```
For packages that are not available using conda install, we can look in the repository Anaconda.org. 
Anaconda.org, formerly Binstar.org, is a package management service for both public and private package 
repositories. 
In a browser, go to http://anaconda.org. 
To find the package named “bottleneck” enter that search term, find the package you want and click to go 
to the detail page. 
There you will see the name of the channel – in this case it is the “pandas” channel.
Now that you know the channel name, you can use the conda install command to get it:
```

|Command|Description|
|---|---|
|conda install -c 'name_package'|install a package|
|conda list|see list of packages available|
|conda update 'name_package'|update a package|

```
If a package is not available from conda or Anaconda.org, you may be able to find and install it with another 
package manager like pip.
```

#### Additional Commands

|Command|Description|
|---|---|
|conda update conda|udpate conda|
|conda update python|update python used by conda|
|conda list|list packages in active environment|
|conda list -n snowflakes|seach for packages in environment named snowflake|
|conda search package_name|search for a package of interest|

---
#### Set Chrome as Your Default Browswer
```
If you haven't already, create a notebook config file by running: jupyter notebook --generate-config

Then, edit the file jupyter_notebook_config.py found in the .jupyter folder of your home directory.
	-once you run jupyter notebook --generate-config, it will tell you where to find the config file 
    in the command window
	-open with word pad or note pad

You need to change the line 
    # c.NotebookApp.browser = '' to
    c.NotebookApp.browser = 'C:/path/to/chrome.exe %s'
    
	-Check on your system to be sure but on windows 10, Chrome should be located at:
        -C:\Program Files (x86)\Google\Chrome\Application\chrome.exe 
	-be sure to remove the #:  if you don't, the line will remain commented out
    -be sure to use forward slashes and not back slashes
```

