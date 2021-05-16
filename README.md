# doc2term

[![pypi](https://badge.fury.io/py/doc2term.svg)](https://pypi.org/project/doc2term/)
[![license](https://img.shields.io/:license-Apache%202-blue.svg)](http://github.com/callforpapers-source/doc2term/blob/master/LICENSE.txt)

A fast NLP tokenizer that detects sentences, words, numbers, urls, hostnames, emails, filenames, and phone numbers. Tokenize integrates and standardize the documents, remove the punctuations and duplications.

## Installation

```
pip install doc2term
```

### Compilation

The installation requires to compile the original C code using `gcc`.

## Usage

Example notebook: [doc2term](http://nbviewer.ipython.org/urls/raw.github.com/callforpapers-source/doc2term/master/examples/word2vec.ipynb)

### Example

```python
>>> import doc2term

>>> doc2term.doc2term_str("Actions speak louder than words. ... ")
"Actions speak louder than words ."
>>> doc2term.doc2term_str("You can't judge a book by its cover. ... from thoughtcatalog.com")
"You can't judge a book by its cover . from thoughtcatalog.com"

```
