## Notes


```
List of Terms / Acronyms
• Cohort
• Corpus and Case Studies
• DSI: Data Source Item (same as document)
• ECs or Equivalence Classes
• Extracted terms / bag-of-words (BoW)
• Hero Team
• Reference Term Vector, or RTV

DSI: Data Source Item 
A DSI (Data Source Item) is a single thing that contributes to the corpus (collection of items that is being evaluated). It is not necessarily a single document - it can be as short and simple as a single Tweet. (More often, though, if a student wanted to contribute a DSI based on tweets, they would assemble a collection of tweets as their DSI.) A DSI can be a transcript of an audio or video presentation. It can be extracts from chat sessions or customer surveys or point-of-sale responses, etc. 

Corpus and Case Studies
A corpus (literally, Latin for "body"; plural corpora) is a collection of DSIs (documents)

Equivalence Classes
The first step that a person needs to do after getting the extracted terms is to define equivalence classes, or ECs. This is a common industry term, and was commonly used by IBM in their text analytics community.
Members of an equivalence class should (preferably) mean exactly the same thing, without ambiguity.  

Extracted Terms / Bag-of-Words
The first step in processing a DSI is to use a term extraction engine to pull out what that extraction engine thinks are the nouns and/or noun phrases. (Depending on the extraction engine, it may also give all the other terms as well, and label them, such as "verb" or "adjective," as well as pulling out the nouns and noun phrases.)
This gives us what is often referred to as a "bag of words" (BoW). Instead of the "bag of words" phrase, we may often use "extracted terms."

Reference Term Vector (RTV)
The Reference Term Vector (RTV) is the vector of terms selected for use in clustering; this vector contains equivalence terms. The values in the vector refer to term counts per DSI. DSIs (documents) are trimmed to approximately 500 words each, before entity extraction (preprocessing steps) has been applied.
Feature engineering for NLP often comes down to fine-tuning the RTV. 
For example, the problems with getting good clusters typically come down to how the clustering algorithm interacts with the features – the terms chosen for the RTV (the Reference Term Vector).
The RTV should not be overly large (and sparse), because that makes it hard for the documents to have sufficient “matches.”
The RTV should not be too small, because the different things that documents would have in common need to be sufficiently represented.
It’s a “Goldilocks problem.” The RTV has to be just right.
```
