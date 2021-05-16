import os
import subprocess
import sys

from setuptools import find_packages, setup
from setuptools.command.install import install


setup_dir = os.path.abspath(os.path.dirname(__file__))


def read_file(filename):
    filepath = os.path.join(setup_dir, filename)
    with open(filepath) as file:
        return file.read()

class InstallCmd(install):
    def run(self):
        print("Running custom Install command")
        compile_all()
        super(InstallCmd, self).run()


def compile_all():
    compile_c("doc2term.c", "doc2term")

def compile_c(source, target):
    this_dir = os.path.abspath(os.path.dirname(__file__))
    c_source = os.path.join(this_dir, "doc2term", "includes")

    target_dir = "bin"

    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    CC = "gcc"

    DEFAULT_CFLAGS = (
        "-lm"
    )

    DEFAULT_CFLAGS += " -I/usr/include/malloc"

    CFLAGS = os.environ.get("doc2term_CFLAGS", DEFAULT_CFLAGS)

    source = os.path.join(c_source, source)
    target = os.path.join(target_dir, target)
    command = [CC, source, "-o", target]
    command.extend(CFLAGS.split(" "))

    print("Compiling:", " ".join(command))
    return_code = subprocess.call(command)

    if return_code > 0:
        exit(return_code)

files = [
    "bin/doc2term"
]
data_files = [("bin", files)]


setup(
    name="doc2term",
    version="0.1.0",
    use_scm_version=True,
    packages=find_packages(),
    include_package_data=True,
    package_data={"doc2term": ["includes/**/*.c"]},
    data_files=data_files,
    cmdclass={"install": InstallCmd},
    entry_points={},
    options={"bdist_wheel": {"universal": "1"}},
    python_requires=">=3.7",
    install_requires=read_file("requirements.txt").splitlines(),
    description="A fast NLP tokenizer that detects tokens and remove"\
                " duplications and punctuations",
    long_description=read_file("README.md"),
    long_description_content_type="text/markdown",
    license="Apache License, Version 2.0",
    maintainer="Saeed Dehqan",
    maintainer_email="saeed.dehghan@owasp.org",
    url="https://github.com/callforpapers-source/doc2term",
    keywords=["tokenizer", "NLP", "punctuation",
              "standarization", "duplicate-detection",
              "text-processing", "text-tokenizing", "doc2term"],
    classifiers=[
        "License :: OSI Approved :: Apache Software License",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
    ]
)
