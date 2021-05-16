import pytest


def test_doc2term_list():
	try:
		import doc2term
		proc = doc2term.doc2term_list([
			"Myth is a folklore genre consisting of narratives that play a fundamental role in a society, such as foundational tales or origin myths",
			"Wisdom, sapience, or sagacity is the ability to think and act using knowledge, experience, understanding, common sense and insight"])
		assert proc != []
	except OSError as e:
		assert "" == e
