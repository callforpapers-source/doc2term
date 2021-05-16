import pytest


def test_doc2term_str():
	try:
		import doc2term
		proc = doc2term.doc2term_str("There's No Time For Us!!")
		assert proc != ""
	except OSError as e:
		assert "" == e
