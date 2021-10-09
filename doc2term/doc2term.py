
import subprocess
import sys


def doc2term(input_text, output_text, include_numbers_dates=0, include_emails_phones_urls=0, include_hosts_files=0, section=0):
    """
    doc2term execution

    Parameters:
        input_text <file>
            Use text data from <file> to run the doc2term
        output <file>
            Use <file> to save the resulting terms
        section <int>
            Which section of output do you want?
            0 means all of results
            1 means term-identifiers
            2 means tokens
            3 means metadata
            default is 0.
        include_numbers_dates <int>
            If it is equal to One, it means that the output shouldn't remove numbers and dates
            default is zero
        include_emails_phones_urls <int>
            If it is equal to One, it means that the output shouldn't remove emails, phones, and urls
            default is zero
        include_hosts_files <int>
            If it is equal to One, it means that the output shouldn't remove hosts and files
            default is zero
    """
    command = ["doc2term"]
    values = [
        input_text,
        output_text,
        str(section)+str(include_numbers_dates)+str(include_emails_phones_urls)+str(include_hosts_files)
    ]

    for value in values:
        command.append(value)

    run_cmd(command)

def doc2term_str(docs, section=2, include_numbers_dates=0, include_emails_phones_urls=0, include_hosts_files=0, format='str'):
    """
    doc2term_str gets a string and return the results in the specified format

    Parameters:
        docs <str>
            Use text data to run the doc2term. each document should be in a new line.
        section <int>
            Which section of output do you want?
            0 means all of results
            1 means term-identifiers
            2 means tokens
            3 means metadata
            default is 2.
        include_numbers_dates <int>
            If it is equal to One, it means that the output shouldn't remove numbers and dates
            default is zero
        include_emails_phones_urls <int>
            If it is equal to One, it means that the output shouldn't remove emails, phones, and urls
            default is zero
        include_hosts_files <int>
            If it is equal to One, it means that the output shouldn't remove hosts and files
            default is zero
        format <str>:
            the output should be in which format? str or list.
            default is list.
            if format=='str', each document is in a new line
            if format=='list', each document is in a new element
    """

    tmp_file = "/tmp/doc2term"

    with open(tmp_file, "w") as fp:

        if docs[-1] != "\n":
            docs = docs + "\n"

        fp.write(docs)

    doc2term(tmp_file, tmp_file, include_numbers_dates, include_emails_phones_urls, include_hosts_files, section)

    with open(tmp_file) as fp:
        read = fp.read()[:-1]

        if format == 'list':
            return read.split('\n')
        else:
            if read[-1] == '\n':
                return read[:-1]

            return read

    return ""

def run_cmd(command):
    """
    command execution

    Run taken command as a process and raise error if any
    """
    proc = subprocess.Popen(command, 
                            stdout=subprocess.PIPE, 
                            stderr=subprocess.PIPE)

    proc.wait()
    if proc.returncode != 0:
        out, err = proc.communicate()
        raise Exception(
            "The tokenizing could not be completed (returncode=%i): %s %s"
            % (proc.returncode, out, err)
        )

    out, err = proc.communicate()
