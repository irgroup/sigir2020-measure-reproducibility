path = {
    # path to compressed files from TREC disks 4 & 5 (minus cr)
    "robust04": "",  # TODO: add path to directory
    # path to compressed files from AQUAINT corpus
    "robust05": "",  # TODO: add path to directory
    # path to compressed files from New York Times corpus
    "core17": "",  # TODO: add path to directory
    # path to (cleaned) text-docs from Washington Post corpus
    "core18_clean": "./data/clean/core18/",
    # path to raw text-docs from Washington Post corpus
    "core18_raw": "./data/raw/core18/",
    # path to (cleaned) text-docs from New York Times corpus
    "core17_clean": "./data/clean/core17/",
    # path to raw text-docs from New York Times corpus
    "core17_raw": "./data/raw/core17/",
    # path to (cleaned) text-docs from Robust04 corpus
    "robust04_clean": "./data/clean/robust04/",
    # path to raw text-docs from Robust04 corpus
    "robust04_raw": "./data/raw/robust04/",
    # path to (cleaned) text-docs from AQUAINT corpus
    "robust05_clean": "./data/clean/robust05/",
    # path to raw text-docs from AQUAINT corpus
    "robust05_raw": "./data/raw/robust05/",
    # path to union corpus of Washington Post and Robust04
    "union_core18_robust04": "./data/clean/union/core18_robust04/",
    # path to union corpus of Washington Post and Robust04
    "union_core18_robust04_raw": "./data/raw/union/core18_robust04/",
    # path to union corpus of Washington Post, AQUAINT and Robust04
    "union_core18_robust0405": "./data/clean/union/core18_robust0405/",
    # path to union corpus of Washington Post, AQUAINT and Robust04
    "union_core18_robust0405_raw": "./data/raw/union/core18_robust0405/",
    # path to union corpus of New York Times and Robust04
    "union_core17_robust04": "./data/clean/union/core17_robust04/",
    # path to union corpus of New York Times, AQUAINT and Robust04
    "union_core17_robust0405": "./data/clean/union/core17_robust0405/",
    # path to union corpus of New York Times, AQUAINT and Robust04 with raw texts
    "union_core17_robust0405_raw": "./data/raw/union/core17_robust0405/",
    # path to union corpus of Robust04 and AQUAINT
    "union_robust0405": "./data/clean/union/robust0405/",
    # path to union corpus of Robust04 and AQUAINT with raw texts
    "union_robust0405_raw": "./data/raw/union/robust0405/",
    # path to union corpus of Robust04 and NYT with raw texts
    "union_core17_robust04_raw": "./data/raw/union/core17_robust04/",
    # path to directory where training features will be written in svm-light format
    "train_feat": "./artifact/feat/topic-based/",
    # path to temporal directory; this folder will be deleted after successful execution
    "tmp": "./data/tmp/",
    # path for temporal directory; this folder will be deleted after successful execution
    "tmp_extract": "./data/extract/",
    # path to directory where resulting complete run will be written
    "complete_run": "./artifact/runs/",
    # path to directory where resulting single runs will be written
    "single_runs": "./artifact/runs/single/",
    # path to directory where scores of a topic run will be written
    "score": "./artifact/score/",
    # path to directory where tfidf-vectorizers will be stored
    "tfidf": "./artifact/tfidf/"
}

file = {
    # path to json lines file of Washington Post corpus
    "core18": "",  # TODO: add path to file
    # path to file where tfidf-vectorizer will be dumped
    "vectorizer_core18_robust04": "./artifact/tfidf/tfidfvectorizer_core18_robust04.pk",
    # path to file where tfidf-vectorizer will be dumped
    "vectorizer_core18_robust0405": "./artifact/tfidf/tfidfvectorizer_core18_robust0405.pk",
    # path to file where tfidf-vectorizer will be dumped
    "vectorizer_core17_robust04": "./artifact/tfidf/tfidfvectorizer_core17_robust04.pk",
    # path to file where tfidf-vectorizer will be dumped
    "vectorizer_core17_robust0405": "./artifact/tfidf/tfidfvectorizer_core17_robust0405.pk",
    # path to shelve where tf-idf-features will be dumped
    "feat_core18_robust04": "./artifact/feat/feat_core18_robust04",
    # path to shelve where tf-idf-features will be dumped
    "feat_core18_robust0405": "./artifact/feat/feat_core18_robust0405",
    # path to shelve where tf-idf-features will be dumped
    "feat_core17_robust04": "./artifact/feat/feat_core17_robust04",
    # path to shelve where tf-idf-features will be dumped
    "feat_core17_robust0405": "./artifact/feat/feat_core17_robust0405",
    # path to file with scores of topic run
    "score_core18_robust04": "artifact/score/score_core18_robust04",
    # path to file with scores of topic run
    "score_core18_robust0405": "./artifact/score/score_core18_robust0405",
    # path to file with scores of topic run
    "score_core17_robust04": "./artifact/score/score_core17_robust04",
    # path to file with scores of topic run
    "score_core17_robust0405": "./artifact/score/score_core17_robust0405",
    # path to qrel-file of Robust 2004
    "qrel_robust04": "./qrels/robust04.txt",
    # path to qrel-file of Common Core 2018
    "qrel_core18": "./qrels/core18.txt",
    # path to qrel-file of Common Core 2017
    "qrel_core17": "./qrels/core17.txt",
    # path to qrel-file of Robust 2005
    "qrel_robust05": "./qrels/robust05.txt",
    # path to merged qrel file of Robust 2004/05
    "qrel_robust0405": "./qrels/qrels0405.txt",
    # path to compiled trec_eval
    "trec_eval": "./trec_eval/trec_eval"
}
