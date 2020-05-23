from .config import path
from .param import constellations

num_con = 1
num_cpu = 4

clean_dir = True  # remove old directories of previous runs
data_prep = False  # extract and normalize test collections
tfidf_vec = True  # derive tfidf-matrix (TfidfVectorizer)
prep_corpus_feature = True  # prepare tfidf-features of test collection
score = True  # train classifier and rank tfidf-features of test collection

# workflow
preprocess = constellations.get(num_con).get('preprocess')
robust_only = constellations.get(num_con).get('robust_only')  # train only with robust data

# classifier
model_type = constellations.get(num_con).get('model_type')  # default: logreg-scikit

# logreg
tol = constellations.get(num_con).get('tol')  # default: 1e-4
C = constellations.get(num_con).get('C')  # default: 1.5
logreg_solver = constellations.get(num_con).get('logreg_solver')  # default: lbfgs
max_iter = constellations.get(num_con).get('max_iter')  # default: 100

# svm
svm_C = constellations.get(num_con).get('svm_C')
svm_kernel = constellations.get(num_con).get('svm_kernel')
svm_gamma = constellations.get(num_con).get('svm_gamma')
svm_tol = constellations.get(num_con).get('svm_tol')
svm_max_iter = constellations.get(num_con).get('svm_max_iter')

# tfidf features
analyzer = constellations.get(num_con).get('analyzer')  # options: 'word', 'char', 'char_wb'
ngram_range = constellations.get(num_con).get('ngram_range')  # default: (1,1) in combination with analyzer = 'word'
max_df = constellations.get(num_con).get('max_df')  # default: 1
min_df = constellations.get(num_con).get('min_df')  # default: 1
max_features = constellations.get(num_con).get('max_features')  # default: 1.0
binary = constellations.get(num_con).get('binary')  # default: False
norm = constellations.get(num_con).get('norm')  # default: l2
use_idf = constellations.get(num_con).get('use_idf')  # default: True
smooth_idf = constellations.get(num_con).get('smooth_idf')  # default: True
sublinear_tf = constellations.get(num_con).get('sublinear_tf')  # default: True

# paths
paths_to_check = [path['core18_raw'],
                  path['core17_raw'],
                  path['robust04_raw'],
                  path['robust05_raw'],
                  path['core18_clean'],
                  path['core17_clean'],
                  path['robust04_clean'],
                  path['robust05_clean'],
                  path['union_core17_robust04'],
                  path['union_core17_robust04_raw'],
                  path['union_core17_robust0405'],
                  path['union_core17_robust0405_raw'],
                  path['union_robust0405'],
                  path['union_robust0405_raw'],
                  path['union_core18_robust04'],
                  path['union_core18_robust04_raw'],
                  path['union_core18_robust0405'],
                  path['union_core18_robust0405_raw'],
                  path['train_feat'],
                  path['tmp'],
                  path['complete_run'],
                  path['single_runs'],
                  path['tfidf'],
                  path['score']]
