SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

TEST_FILE ?= "doc2term/tests/"


first: help


# ------------------------------------------------------------------------------
# Build

install:  ## Install package
	python3 setup.py install


build:  ## Build package by sdist
	python3 setup.py sdist


build-default:  ## Build package by build (recommended)
	python3 -m build


uninstall:  ## Uninstall package
	pip uninstall doc2term


upload-pypi:  ## Upload package to PyPI
	python3 -m twine upload dist/*.tar.gz


upload-test:  ## Upload package to test PyPI
	python3 -m twine upload --repository test dist/*.tar.gz


# ------------------------------------------------------------------------------
# Testing

check:  ## Check linting
	flake8
	isort . --project doc2term --check-only --diff
	black . --check


fmt:  ## Format source
	isort . --project doc2term
	black .


test:  ## Run tests
	pytest "$(TEST_FILE)"


test-data:  ## Download test data
	doc2term data/test/simple-docs.txt data/test/output-simple-docs.txt

# ------------------------------------------------------------------------------
# Other

clean:  ## Clean build files
	rm -rf build dist site htmlcov .pytest_cache .eggs
	rm -f .coverage coverage.xml word2vec/_generated_version.py
	find . -type f -name '*.py[co]' -delete
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type d -name .ipynb_checkpoints -exec rm -rf {} +
	rm -rf data/test*


cleanall: clean   ## Clean everything
	rm -rf *.egg-info
	rm -rf bin


help:  ## Show this help menu
	@grep -E '^[0-9a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'
