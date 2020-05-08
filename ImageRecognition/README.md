

## Common packages

```
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from skimage.io import imread, imshow
import cv2
import os, os.path

%matplotlib inline
import plotly.offline as py
py.init_notebook_mode(connected=True)
import plotly.graph_objs as go
import plotly.tools as tls

from subprocess import check_output

import piexif
from collections import defaultdict

import math
```


## Show an image currently in a folder
```
import imageio

a=imageio.imread('C:\\Users\\path\\996resCroppedres.jpg')
plt.imshow(a)
```

## Show an image currently in a df or nparray
```
plt.imshow(arr_images_gr[0])
```

