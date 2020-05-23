import os
import json
import shutil
import functools
from multiprocessing import Pool, cpu_count
from bs4 import BeautifulSoup
from tqdm import tqdm
from nltk.tokenize import RegexpTokenizer
from nltk.stem.porter import PorterStemmer
from nltk.corpus import stopwords
from config import settings


def _parallel_copy(file_name, union, input):
    src = input+file_name
    dst = union+file_name
    shutil.copyfile(src, dst)


def unify(union, corpora_list):
    '''Use this method to make a union corpus from individual corpora.
    :param union: path to union corpus
    :param corpora_list: list with paths to corpora which will be unified
    :return: -
    '''
    if not os.path.exists(union):
        os.makedirs(union)

    cores = settings.num_cpu
    p = Pool(cores)
    for corpus in corpora_list:
        p.map(functools.partial(_parallel_copy, union=union, input=corpus), os.listdir(corpus))


def _parse_trec(full_path_file, tmp, dir_raw_txt):

    skip_list = [
        'credtd.z',
        'crhdtd.z',
        'fr94dtd.z',
        'ftdtd.z',
        'readfrcg.z',
        'readmeft.z',
        'readchg.z',
        'readmefr.z'
    ]

    name = os.path.basename(os.path.normpath(full_path_file))

    if name not in skip_list:

        if name.endswith(tuple([".0z", ".1z", ".2z"])):
            end = '_' + os.path.splitext(name)[1][1]
            doc_path_tmp = tmp + name[:-3] + end
            ending = name[-3:]
            os.system("gzip -d -k -S " + ending + " " + full_path_file)
            os.system("mv " + full_path_file[:-3] + " " + doc_path_tmp)
        if name.endswith(".z"):
            doc_path_tmp = tmp + name[:-2]
            os.system("gzip -d -k " + full_path_file)
            os.system("mv " + full_path_file[:-2] + " " + doc_path_tmp)
        if name.endswith(".gz"):
            doc_path_tmp = tmp + name[:-3]
            os.system("gzip -d -k " + full_path_file)
            os.system("mv " + full_path_file[:-3] + " " + doc_path_tmp)

        markup = open(doc_path_tmp, 'r', encoding="ISO-8859-1")
        try:
            text = markup.read()
        except Exception as e:
            print("BS4 cannot read file: " + doc_path_tmp)

        soup = BeautifulSoup(text, "lxml")
        findings = soup.find_all("doc")

        for finding in findings:
            try:
                # .split() is necessary to remove whitespaces in file names
                file_name = finding.find("docno").contents[0].split()[0]
                output = open(tmp + file_name, "w")
                output.write(str(finding))
                output.close()
            except Exception as e:
                print("Cannot extract document: " + file_name)

            try:
                file = open(tmp + file_name, 'r')
                text = file.read()
                soup = BeautifulSoup(text, "lxml")

                docno = soup.find("docno").contents[0].split()[0]

                completetext = ''

                if soup.find('headline') is not None:
                    completetext += soup.find('headline').text

                if soup.find('text') is not None:

                    try:
                        if len(soup.find('text').contents) == 1:
                            completetext = soup.find("text").text

                        else:  # else-case for documents from la-times
                            for content in soup.find('text').contents:
                                try:

                                    raw_txt = BeautifulSoup(str(content), "lxml")
                                    completetext += raw_txt.text
                                except Exception as e:
                                    pass

                    except Exception as e:
                        print("Could not write raw text for file: ", tmp + name[:-2])

                if soup.find('graphic') is not None:
                    completetext += soup.find('graphic').text

                if soup.find('dateline') is not None:
                    completetext += soup.find('dateline').text

                if soup.find('correction') is not None:
                    completetext += soup.find('correction').text

                if completetext != '':
                    with open(dir_raw_txt + docno, "w") as output:
                        output.write(completetext)

                else:
                    print('No text in file found: ' + docno)

            except Exception as e:
                print("Could not open file with name: ", name[:-2])


def raw_text_from_trec(trec_data, tmp, dir_raw_txt):
    '''This function will decompress TREC files and write single files containing texts of the documents.
    :param trec_data: path to compressed files of TREC disks 4 and 5
    :param tmp: path to temporal directory for uncompressed files, will be deleted afterwards
    :param dir_raw_txt: path to directory where single raw text document files will be written
    :return: -
    '''
    print("Extracting documents from compressed TREC files.")

    if not os.path.exists(tmp):
        os.makedirs(tmp)

    if not os.path.exists(dir_raw_txt):
        os.makedirs(dir_raw_txt)

    cores = settings.num_cpu
    p = Pool(cores)

    exclude = set(['cr'])

    full_path = []
    for path, subdirs, files in os.walk(trec_data):

        subdirs[:] = [s for s in subdirs if s not in exclude]

        extensions = tuple([".z", ".0z", ".1z", ".2z", ".gz"])
        files = [fi for fi in files if fi.endswith(extensions)]
        for fi in files:
            full_path.append(os.path.join(path, fi))

    p.map(functools.partial(_parse_trec, tmp=tmp, dir_raw_txt=dir_raw_txt), full_path)

    shutil.rmtree(tmp, ignore_errors=True)


def raw_text_from_wapo(wapo_jl, wapo_raw):
    '''This function will read from the JSON lines file and write single files containing texts of the documents.
    :param wapo_jl: path to json lines file of Washington Post corpus
    :param wapo_raw: path to raw text-docs from Washington Post corpus
    :return: -
    '''
    if not os.path.exists(wapo_raw):
        os.makedirs(wapo_raw)

    with open(wapo_jl, 'r') as f:
        for line in f:
            obj = json.loads(line)
            with open(wapo_raw + obj['id'], "w") as output:
                text = ""
                for content in obj['contents']:
                    try:
                        con = content.get('content')
                        if con is not None:
                            try:
                                soup = BeautifulSoup(con)
                                text += soup.text
                                text += '\n'
                            except Exception as e:
                                pass  # soup may not have text
                    except Exception as e:
                        print("Beautifulsoup cannot get content for: ", obj['id'])

                if text != '':
                    output.write(text)
                else:
                    print("No text found...")


def _extract_times(file, extraction_dir):
    os.system("tar -xzf " + str(file) + " -C " + extraction_dir)


def _parse_times(file, raw_text_dir):

    markup = open(file, 'r')
    try:
        text = markup.read()
    except Exception as e:
        print("BS4 cannot read file: " + file)

    soup = BeautifulSoup(text, "lxml")

    raw_text = soup.text

    if file[-11:] == '0000000.xml':  # consider special case for first document
        write_name = '0'
    else:
        write_name = file[-11:-4].lstrip("0")

    dst = raw_text_dir + write_name
    with open(dst, 'w') as output:
        output.write(raw_text)


def raw_text_from_times(times_data, extraction_dir, raw_text_dir):
    '''This function will decompress NYT files and write single files containing texts of the documents.
    :param times_data: path to compressed files from New York Times corpus
    :param extraction_dir: path for temporal directory; this folder will be deleted after successful execution
    :param raw_text_dir: path to raw text-docs from New York Times corpus
    :return: -
    '''

    if not os.path.exists(extraction_dir):
        os.makedirs(extraction_dir)

    cores = settings.num_cpu
    p = Pool(cores)

    # Uncompress files
    print("Extracting files")

    full_path = []
    for path, subdirs, files in os.walk(times_data):

        extensions = tuple([".tgz"])
        files = [fi for fi in files if fi.endswith(extensions)]
        for fi in files:
                full_path.append(os.path.join(path, fi))

    p.map(functools.partial(_extract_times, extraction_dir=extraction_dir), full_path)

    # Write raw text content
    print("Extracting raw text")

    full_path = []
    for path, subdirs, files in os.walk(extraction_dir):

        extensions = tuple([".xml"])
        files = [fi for fi in files if fi.endswith(extensions)]
        for fi in files:
                full_path.append(os.path.join(path, fi))

    p.map(functools.partial(_parse_times, raw_text_dir=raw_text_dir), full_path)

    shutil.rmtree(extraction_dir, ignore_errors=True)


def _remove_punctuation(raw_text):
    tokenizer = RegexpTokenizer(r'\w+')
    words = tokenizer.tokenize(raw_text)

    return words


def _remove_stop_words(words):
    stop_words = set(stopwords.words('english'))
    text_filter = []
    for w in words:
        if w.lower() not in stop_words:
            text_filter.append(w.lower())

    return text_filter


def _stem_raw_text(text_filter):
    stemmer = PorterStemmer()
    text_stem = [stemmer.stem(word) for word in text_filter]

    return text_stem


def _clean(name, input, output, wapo):
    if wapo:
        raw_text = open(input + name, 'r').read()
    else:
        raw_text = open(input + name, 'r', encoding="ISO-8859-1").read()
    words = _remove_punctuation(raw_text)
    text_filter = _remove_stop_words(words)
    text_stem = _stem_raw_text(text_filter)

    with open(output + name, 'w') as output:
        for content in text_stem:
            output.write(content + " ")


def clean_raw_text(corpus_raw, corpus_clean, wapo=False):
    '''Use this function for the removal of punctuation, stop words and for stemming words.
    :param corpus_raw: path to raw text-docs from corpus
    :param corpus_clean: path to cleaned text-docs from corpus
    :param wapo: boolean indicating whether the Washington Post corpus will be processed
    :return: -
    '''
    print("Starting text normalization")
    cores = settings.num_cpu
    p = Pool(cores)
    p.map(functools.partial(_clean, input=corpus_raw, output=corpus_clean, wapo=wapo), os.listdir(corpus_raw))
