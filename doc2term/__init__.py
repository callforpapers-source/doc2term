from .doc2term import doc2term  # noqa
from .doc2term import doc2term_str  # noqa
from .doc2term import doc2term_list  # noqa

__doc__ = "A fast NLP tokenizer that detects tokens and"\
	" remove duplications and punctuations."\
	" e.g doc2term.doc2term('input.txt', 'output.txt')."\
	" doc2term_str(docs) gets a string and return the results"\
	" in string format."\
	" doc2term_list(docs) gets a list of documents and return"\
	" results in string format."
