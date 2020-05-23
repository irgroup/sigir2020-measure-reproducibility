import subprocess
from io import StringIO
import pandas as pd
from core.util import directory_list


def merge_single_topics(dir_single_runs, run_complete):
    '''This function will merge runs from single topics to one single run file.
    :param dir_single_runs: path to directory where resulting single runs will be written
    :param run_complete: path to directory where resulting complete run will be written
    :return: -
    '''
    files = directory_list(dir_single_runs)

    with open(run_complete, 'w') as outfile:
        for file in files:
            with open(file) as infile:
                for line in infile:
                    outfile.write(line)


def evaluate(trec_eval, corpus_qrel, run_file_name):
    '''This function will call trec_eval.
    :param trec_eval: path to compiled trec_eval
    :param corpus_qrel: path to qrel-file
    :param run_file_name: path to run file
    :return: -
    '''
    print("Evaluate run...")
    output = subprocess.run([trec_eval + ' ' + corpus_qrel + ' ' + run_file_name], shell=True)
    print(output)


def trec_eval_to_dict(trec_eval_output, topics=None):
    '''This function will parse the trec_eval output (taken from a subprocess call) to a python dictionary.
    :param trec_eval_output: output taken from subprocess call
    :param topics: list with topics which should be considered
    :return: dictionary with trec_eval results
    '''
    output_text = StringIO(str(trec_eval_output.stdout, 'utf-8'))

    df = pd.read_csv(output_text, sep='\t', names=['measure', 'topic', 'value'])

    if topics is None:
        topics = df['topic'].unique()

    trec_eval_result = {}

    for topic in topics:

        tmp_dict = {}

        topic_result = df.loc[df['topic'] == str(topic)]

        for i in range(0, len(topic_result)):
            measure = topic_result.iloc[i, 0].split()[0]
            value = topic_result.iloc[i, 2]
            tmp_dict[measure] = value

        trec_eval_result[str(topic)] = tmp_dict

    return trec_eval_result
