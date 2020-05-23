import os
import shutil
import pandas as pd


def check_path(paths_to_check):
    '''Make sure paths from provided list exist.
    :param paths_to_check: list containing paths
    :return: -
    '''
    for p in paths_to_check:
        if not os.path.exists(p):
            os.makedirs(p)


def clear_path(paths_to_clear):
    '''Make sure paths from provided list will be deleted.
    :param paths_to_clear: list containig paths.
    :return: -
    '''
    for p in paths_to_clear:
        if os.path.exists(p):
            shutil.rmtree(p, ignore_errors=True)


def delete_shelve(shelve):
    '''This function will delete a python shelve.
    :param shelve: path to shelve
    :return: -
    '''
    try:
        os.remove(shelve+'.bak')
    except Exception as e:
        print("File does not exist")
    try:
        os.remove(shelve+'.dat')
    except Exception as e:
        print("File does not exist")
    try:
        os.remove(shelve + '.dir')
    except Exception as e:
        print("File does not exist")
    try:
        os.remove(shelve)
    except Exception as e:
        print("File does not exist")


def find_inter_top(qrel_files):
    '''This function will find intersecting topics between two or more qrel files.
    :param qrel_files: list containing path to two or more qrel-files
    :return: list with intersecting topics
    '''
    qrel_ids = []

    for file in qrel_files:
        qrel = pd.read_csv(file, delimiter='\s+')
        unique = qrel.iloc[:, 0].unique()
        id = pd.Index(unique)
        qrel_ids.append(id)

    if len(qrel_ids) != 0:
        inter = qrel_ids[0]

        for i in range(1, len(qrel_ids)):
            inter = inter.intersection(qrel_ids[i])

        return inter

    else:
        print("No topics found ...")
        return None


def directory_list(directory):
    '''This function will return a list of files in a directory.
    :param directory: path to directory
    :return: list with paths to files
    '''
    dirlist = []
    for dirpath, _, filenames in os.walk(directory):
        for f in filenames:
            dirlist.append(os.path.abspath(os.path.join(dirpath, f)))

    return dirlist


def merge_qrels(qrel_files, merge_file):
    '''This function will concatenate the contents of two or more qrel files.
    :param qrel_files: list with qrel-files
    :param merge_file: path to concatenated qrel-file
    :return: -
    '''
    with open(merge_file, 'w') as outfile:
        for file in qrel_files:
            with open(file) as infile:
                for line in infile:
                    outfile.write(line)
