import pickle
import csv
import numpy as np
from scipy.sparse import vstack, csr_matrix
from sklearn import svm
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import dump_svmlight_file, load_svmlight_file
from core.tfidf_vectorization import load_vectorizer
from config import settings


def prep_train_feat(vectorizer_pick, qrel, topic, training_corpus, train_feat):
    '''This function will prepare features in svm-light format for the training of the logistic regression model.
    Training will be done on a specified topic with documents from a selected corpus.
    :param vectorizer_pick: path to file where tfidf-vectorizer will be dumped
    :param qrel: path to qrel file from which tfidf-features are picked
    :param topic: topic number
    :param training_corpus: path to corpus from which tfidf-features are computed
    :param train_feat: path to svmlight-file
    :return: the number of tfidf-features has to be returned in order to hand it over in a subsequent step
    '''
    vectorizer = load_vectorizer(vectorizer_pick)

    y = []
    tfidf = csr_matrix([])

    init = 1

    with open(qrel) as file:
        for entry in csv.reader(file):

            entry_split = entry[0].split()
            topic_tmp = entry_split[0]
            doc_name = entry_split[2]
            relevance = entry_split[3]

            if str(topic) == topic_tmp:
                doc_path = training_corpus + doc_name

                try:
                    doc_tfidf = vectorizer.transform([doc_path])
                    if init == 1:
                        tfidf = vstack([doc_tfidf])
                        init = 0
                    else:
                        tfidf = vstack([tfidf, doc_tfidf])

                    if int(relevance) == 2:  # Grossman and Cormack convert relevance assessments to a binary scale
                        y.append(1)
                    else:
                        y.append(int(relevance))
                except:
                    print("Missing document with id: ", doc_name)

    dump_svmlight_file(tfidf, np.array(y), train_feat+'tfidf_feat_'+str(topic), multilabel=False)

    return tfidf.shape[1]


def train(train_feat, topic, n_feat, model_type='logreg-scikit'):
    '''Use this function to train a logistic regression model with the help of a provided svm-light file.
    :param train_feat: the previously derived tfidf training features (svm-light formatted)
    :param topic: topic number
    :param n_feat: number of features (returned by prep_train_feat())
    :param model_type: define type of model, choose from 'logreg-scikit', 'logreg-sofia' and 'svm-scikit'
    :return: model which results from the training
    '''
    x_train, y_train = load_svmlight_file(train_feat+'tfidf_feat_'+str(topic), n_features=n_feat)

    if model_type == 'logreg-scikit':
        model = LogisticRegression(C=settings.C,
                                   solver=settings.logreg_solver,
                                   tol=settings.tol)
        model.fit(x_train, y_train)

    if model_type == 'svm-scikit':
        model = svm.SVC(probability=True,
                        kernel=settings.svm_kernel,
                        C=settings.svm_C,
                        gamma=settings.svm_gamma,
                        tol=settings.svm_tol,
                        max_iter=settings.max_iter)
        model.fit(x_train, y_train)

    return model
