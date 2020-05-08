# see path below for the github this comes from

from __future__ import print_function
 
 
from sklearn.feature_extraction.text import  CountVectorizer
from sklearn.decomposition import  LatentDirichletAllocation
from collections import Counter
import pandas as pd
import re
import tensorflow as tf
from sklearn.model_selection import train_test_split
import random
 
 
raw_data=pd.read_csv("C:/Users/hucen/GitHub/pro/python/enrollment_rate/citeline_rare_disease.csv", header=1,
                     names = ['INCLD_CRTERIA','EXCLD_CRTERIA'], encoding="ISO-8859-1")
 
whole_data=pd.read_csv("C:/Users/hucen/GitHub/pro/python/enrollment_rate/citeline_rare_disease.csv", header=0,
                     encoding="ISO-8859-1")
 
 
whole_data_non=whole_data.dropna()
 
incld_list=whole_data_non['INCLD_CRTERIA'].tolist()
 
excld_list=whole_data_non['EXCLD_CRTERIA'].tolist()
 
 
 
 
n_samples = len(raw_data)
n_features = round(n_samples/6)
n_topics = len(whole_data.groupby('PRA_STUDY_ID')['PRA_STUDY_ID'].count())
n_top_words = 20
 
 
def print_top_words(model, feature_names, n_top_words):
    list_term_temp=[]
    #list_idx=[]
 
    for topic_idx, topic in enumerate(model.components_):
        #list_term_temp=[]
        #print("Topic #%d:" % topic_idx)
        #list_idx.append(topic_idx)
        #print(" ".join([feature_names[i]
        #                for i in topic.argsort()[:-n_top_words - 1:-1]]))
        for i in topic.argsort()[:-n_top_words -1:-1]:
            list_term_temp.append(feature_names[i])
            
        #list_term.append(list_term_temp)
    
    #dic=pd.DataFrame({'topic_index':list_idx, 'terms':list_term})
    #print()
    return list_term_temp
 
 
 
 
data_samples_incld = incld_list
data_samples_excld = excld_list
 
 
tf_vectorizer_incld = CountVectorizer(max_df=0.6, min_df=4,
                                max_features=n_features,
                                stop_words='english')
 
tf_vectorizer_excld = CountVectorizer(max_df=0.6, min_df=4,
                                max_features=n_features,
                                stop_words='english')
 
tf_incld = tf_vectorizer_incld.fit_transform(data_samples_incld)
 
tf_excld = tf_vectorizer_excld.fit_transform(data_samples_excld)
 
 
 
print("Fitting LDA models with tf features, "
      "n_samples=%d and n_features=%d..."
      % (n_samples, n_features))
 
lda = LatentDirichletAllocation(n_topics=n_topics, max_iter=5,
                                learning_method='online',
                                learning_offset=50.,
                                random_state=0)
 
lda_incld = lda.fit(tf_incld)
lda_excld = lda.fit(tf_excld)
 
 
tf_feature_names_incld = tf_vectorizer_incld.get_feature_names()
incld_terms = print_top_words(lda_incld, tf_feature_names_incld, n_top_words)
 
tf_feature_names_incld = tf_vectorizer_excld.get_feature_names()
excld_terms = print_top_words(lda_excld, tf_feature_names_incld, n_top_words)
 
 
incld_terms_list = list(dict(Counter(incld_terms).most_common(100)))
excld_terms_list = list(dict(Counter(excld_terms).most_common(100)))
 
unique_incld = list(set(incld_terms_list) - set(excld_terms_list))
unique_excld = list(set(excld_terms_list) - set(incld_terms_list)) 
