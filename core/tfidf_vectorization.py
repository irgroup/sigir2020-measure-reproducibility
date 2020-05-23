import time
import re
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk.stem.porter import PorterStemmer
from nltk.stem.snowball import SnowballStemmer
from core.util import directory_list
from config import settings


def _stemming(str_input):
    stemmer = PorterStemmer()
    words = re.sub(r"[^A-Za-z0-9\-]", " ", str_input).lower().split()
    words = [stemmer.stem(word) for word in words]
    return words


def dump_tfidf_vectorizer(vectorizer_pick, union):
    '''Use this function to pickle a vectorizer object. The tfidf-vectorizer object will be made from
    files of a specified directory.
    :param vectorizer_pick: path to file where pickled vectorizer will be written
    :param union: path to directory of union corpus
    :return: -
    '''

    print('Dumping tfidf-vectorizer')
    union_list = directory_list(union)

    # set min_df to 0.2 in order to prevent memory errors, default val = 1.0
    # handing over a tokenizer will result in long processing times, better perform stemming with
    # an extra script/function
    pre_vectorizer = TfidfVectorizer(input='filename',
                                 analyzer=settings.analyzer,
                                 ngram_range=settings.ngram_range,
                                 max_df=settings.max_df,
                                 min_df=settings.min_df,
                                 max_features=None,
                                 binary=settings.binary,
                                 norm=settings.norm,
                                 use_idf=settings.use_idf,
                                 smooth_idf=settings.smooth_idf,
                                 sublinear_tf=settings.sublinear_tf)

    start_time = time.time()
    pre_vectorizer.fit(union_list)

    vectorizer = TfidfVectorizer(input='filename',
                                 analyzer=settings.analyzer,
                                 ngram_range=settings.ngram_range,
                                 max_df=settings.max_df,
                                 min_df=settings.min_df,
                                 max_features=int(settings.max_features*len(pre_vectorizer.vocabulary_)),
                                 binary=settings.binary,
                                 norm=settings.norm,
                                 use_idf=settings.use_idf,
                                 smooth_idf=settings.smooth_idf,
                                 sublinear_tf=settings.sublinear_tf)

    vectorizer.fit(union_list)
    print("Time needed for making tfidf-matrix: ", str(time.time() - start_time))

    with open(vectorizer_pick, 'wb') as dump:
        pickle.dump(vectorizer, dump)


def load_vectorizer(vectorizer_pick):
    '''Use this function to load a vectorizer object from a pickle file.
    :param vectorizer_pick: path to file where tfidf-vectorizer are dumped
    :return: -
    '''
    # print('Loading tfidf-vectorizer...')
    vectorizer_file = open(vectorizer_pick, 'rb')
    vectorizer = pickle.load(vectorizer_file)

    return vectorizer
