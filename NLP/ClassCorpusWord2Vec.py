

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Sep 29 21:06:55 2018
@author: paulhuynh
"""
###############################################################################
### packages required to run code.  Make sure to install all required packages.
###############################################################################
import re,string
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
import pandas as pd
import os
from gensim.models import Word2Vec
###############################################################################
### Function to process documents
###############################################################################
def clean_doc(doc): 
    #split document into individual words
    tokens=doc.split()
    re_punc = re.compile('[%s]' % re.escape(string.punctuation))
    # remove punctuation from each word
    tokens = [re_punc.sub('', w) for w in tokens]
    # remove remaining tokens that are not alphabetic
    tokens = [word for word in tokens if word.isalpha()]
    # filter out short tokens
    tokens = [word for word in tokens if len(word) > 4]
    #lowercase all words
    tokens = [word.lower() for word in tokens]
    # filter out stop words
    stop_words = set(stopwords.words('english'))
    tokens = [w for w in tokens if not w in stop_words]         
    # word stemming    
    ps=PorterStemmer()
    tokens=[ps.stem(word) for word in tokens]
    return tokens
###############################################################################
### Processing text into lists
###############################################################################
#set working Directory to where class corpus is saved.
os.chdir(r'C:\Users\phuynh\Downloads')
#read in class corpus csv into python
data=pd.read_csv('Class Corpus.csv')
#create empty list to store text documents titles
titles=[]
#for loop which appends the DSI title to the titles list
for i in range(0,len(data)):
    temp_text=data['DSI_Title'].iloc[i]
    titles.append(temp_text)
#create empty list to store text documents
text_body=[]
#for loop which appends the text to the text_body list
for i in range(0,len(data)):
    temp_text=data['Text'].iloc[i]
    text_body.append(temp_text)
#Note: the text_body is the unprocessed list of documents read directly form 
#the csv.
    
#empty list to store processed documents
processed_text=[]
#for loop to process the text to the processed_text list
for i in text_body:
    text=clean_doc(i)
    processed_text.append(text)
#Note: the processed_text is the PROCESSED list of documents read directly form 
#the csv.  Note the list of words is separated by commas.
#stitch back together individual words to reform body of text
final_processed_text=[]
for i in processed_text:
    temp_DSI=i[0]
    for k in range(1,len(i)):
        temp_DSI=temp_DSI+' '+i[k]
    final_processed_text.append(temp_DSI)
    
#Note: We stitched the processed text together so the TFIDF vectorizer can work.
#Final section of code has 3 lists used.  2 of which are used for further processing.
#(1) text_body - unused, (2) processed_text (used in W2V), 
#(3) final_processed_text (used in TFIDF), and (4) DSI titles (used in TFIDF Matrix)
 
###############################################################################
### Sklearn TFIDF 
###############################################################################
#Call Tfidf Vectorizer
Tfidf=TfidfVectorizer()
#fit the vectorizer using final processed documents.  The vectorizer requires the 
#stiched back together document.
X=Tfidf.fit_transform(final_processed_text)     
#creating datafram from TFIDF Matrix
matrix=pd.DataFrame(X.toarray(), columns=Tfidf.get_feature_names(), index=titles)
#can export matrix to csv and explore further if necessary
###############################################################################
### Gensim Word2vec 
###############################################################################
#word to vec
model = Word2Vec(processed_text, size=100, window=5, min_count=1, workers=4)
#join all processed DSI words into single list
processed_text_w2v=[]
for i in processed_text:
    for k in i:
        processed_text_w2v.append(k)
#obtian all the unique words from DSI
w2v_words=list(set(processed_text_w2v))
#can also use the get_feature_names() from TFIDF to get the list of words
#w2v_words=Tfidf.get_feature_names()
#empty dictionary to store words with vectors
w2v_vectors={}
#for loop to obtain weights for each word
for i in w2v_words:
    temp_vec=model.wv[i]
    w2v_vectors[i]=temp_vec
#create a final dataframe to view word vectors
w2v_df=pd.DataFrame(w2v_vectors).transpose()
