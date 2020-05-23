import collections
import pandas as pd


def rank(docid_score, topic, path_single_runs):
    ''' This function will rank entries of a given file with doc-ids and corresponding scores.
    Afterwards a run file with the 10,000 first entries will be written for the specified topic.
    :param docid_score: path to directory where scores of a topic run will be written
    :param topic: topic number
    :param path_single_runs: path to directory where resulting single runs will be written
    :return: -
    '''
    print('Producing run...')

    run_file_name = path_single_runs + 'topic_' + str(topic)

    scores = pd.read_csv(docid_score, delimiter='\s+', names=['docid', 'scores'])
    score_dict = {row[0]: row[1] for row in scores.values}
    sort = sorted(score_dict.items(), key=lambda kv: kv[1])
    sorted_dict = collections.OrderedDict(sort)
    run = ''

    for i in range(0, 10000):  # Grossman and Cormack use the first 10,000 entries to produce their runs

        doc_and_score = sorted_dict.popitem()
        docid = doc_and_score[0]

        if isinstance(docid, float):
            docid = str(int(docid))
        else:
            docid = str(docid)

        score = doc_and_score[1]
        run += str(topic) + " " + "Q0" + " " + docid + " " + str(i) + " " + str(score) + " " + "IRC" + "\n"

    with open(run_file_name, "w") as output:
        output.write(run)
