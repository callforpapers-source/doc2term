# doc2term

[![Build Status](https://travis-ci.com/callforpapers-source/doc2term.svg?branch=main)](https://travis-ci.com/callforpapers-source/doc2term)
[![pypi](https://badge.fury.io/py/doc2term.svg)](https://pypi.org/project/doc2term/)
[![license](https://img.shields.io/:license-Apache%202-blue.svg)](http://github.com/callforpapers-source/doc2term/blob/master/LICENSE.txt)

A fast NLP tokenizer that detects sentences, words, numbers, urls, hostnames, emails, filenames, dates, and phone numbers. Tokenize integrates and standardize the documents, remove the punctuations and duplications.

## Installation

```
git clone https://github.com/callforpapers-source/doc2term
cd doc2term
python setup.py install
```

### Compilation

The installation requires to compile the original C code using `gcc`.

## Usage

Example notebook: [doc2term](https://nbviewer.jupyter.org/github/callforpapers-source/doc2term/blob/main/examples/doc2term.ipynb)

### Example

```python
>>> import doc2term

>>> doc2term.doc2term_str("Actions speak louder than words. ... ")
"Actions speak louder than words ."
>>> doc2term.doc2term_str("You can't judge a book by its cover. ... from thoughtcatalog.com")
"You can't judge a book by its cover . from"

>>> doc2term.doc2term_str("You can't judge a book by its cover. ... from thoughtcatalog.com", include_hosts_files=1)
"You can't judge a book by its cover . from thoughtcatalog.com"
```
