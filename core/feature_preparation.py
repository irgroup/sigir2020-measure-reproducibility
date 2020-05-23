import os
import time
import shelve
from tqdm import tqdm
from core.tfidf_vectorization import load_vectorizer


def prepare_corpus_feature(vectorizer_pick, corpus, corpus_feat):
    '''Use this function to precompute tfidf-features from single documents of corpus.
    :param vectorizer_pick: path to dumped tfidf-vectorizer
    :param corpus: path to corpus with (cleaned) text document files
    :param corpus_feat: path to shelve where tf-idf-features are dumped
    :return: -
    '''

    # Load tfidf-vectorizer
    vectorizer = load_vectorizer(vectorizer_pick)

    # Prediciton
    print('Retrieving tfidf-features for corpus...')
    start_time = time.time()
    id_and_tfidf = shelve.open(corpus_feat)

    for path, subdirs, files in os.walk(corpus):

        for file in files:
            docpath = path + file
            doc_tfidf = vectorizer.transform([docpath], copy=True)
            id_and_tfidf[file] = doc_tfidf

    id_and_tfidf.close()
    print('Took ', time.time() - start_time, ' seconds.')
