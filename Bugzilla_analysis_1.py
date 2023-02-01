#!/usr/bin/env python
# coding: utf-8

# # importing libraries

# In[1]:


import pandas as pd
import numpy as np
import csv
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib
import re


# # Loading the data frame

# In[2]:


pd.set_option=("display.max_colwidth",'100')

df1=pd.read_csv("bugzilla_3.csv")
df1


# # Data Cleaning

# In[3]:


df2=df1.drop(['type','resolution','status','assignee'],axis=1)
df2['summary']=df2['summary'].str.lower()
df2.head()


# In[4]:


df2.dtypes


# In[6]:


#grouping by product and components
#df3=pd.concat(g for _, g in df2.groupby("comp") if len(g) > 1)
df3=df2
df3


# In[7]:


#removing punctuations from the summary

import string

string.punctuation

#creating a function
def remove_punctuation(txt):
    txt_nopunt="".join([c for c in txt if c not in string.punctuation])
    return txt_nopunt


df3['msg_clean']=df3['summary'].apply(lambda x:remove_punctuation(x))
df3




# In[8]:


#tokenizing the msg_clean

import re

def tokenize(text):
    tokens=re.split('\W+',text)
    return tokens

df3['summary_tokenized']=df3['msg_clean'].apply(lambda x: tokenize(x.lower()))

df3


# In[9]:


#importing nltk to remove stopwords from the summary_tokenized

import nltk
nltk.download('stopwords')
stopwords=nltk.corpus.stopwords.words('english')

def remove_stopwords(txt_tokenized):
    txt_clean=[word for word in txt_tokenized if word not in stopwords]
    return txt_clean


df3['no_swds']=df3['summary_tokenized'].apply(lambda x: remove_stopwords(x))
df3


# In[11]:


#Lemmatizing the no_swds column to get the root word 'Lemma' 


nltk.download('wordnet')
nltk.download('omw-1.4')
wn=nltk.WordNetLemmatizer()


def lemmatization(token_txt):
    text=[wn.lemmatize(word) for word in token_txt]
    return text

df3['lemmatized_wrds']=df3['no_swds'].apply(lambda x: lemmatization(x))
df3.head()


# In[40]:


from collections import Counter


df4=','.join(' '.join(l) for l in df3['lemmatized_wrds'])
df4
#word_counts = Counter(df4)
#n = 10
#most_common_words = word_counts.most_common()
#most_common_words


# In[13]:



from sklearn.feature_extraction.text import TfidfVectorizer

vectorizer = TfidfVectorizer()

tfidf_matrix = vectorizer.fit_transform(df3['msg_clean'])

tfidf_df = pd.DataFrame(tfidf_matrix.todense(), columns=vectorizer.get_feature_names())

tfidf_df


# In[14]:


from sklearn.preprocessing import MultiLabelBinarizer

count_vec = MultiLabelBinarizer()
mlb = count_vec.fit(df3["lemmatized_wrds"])
df5=pd.DataFrame(mlb.transform(df3["lemmatized_wrds"]), columns=[mlb.classes_])
df5


# In[15]:


def drop_columns(df, threshold):
    columns_to_drop = []
    for col in df.columns:
        if df[col].eq(1).sum() < threshold:
            columns_to_drop.append(col)
    df.drop(columns=columns_to_drop, inplace=True)
    return df


# In[16]:


df6=drop_columns(df5,20)
df6


# In[ ]:


z = df6['zoom'].eq(0).sum()
z


# In[ ]:




