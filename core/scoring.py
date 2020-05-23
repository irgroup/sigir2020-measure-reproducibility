from multiprocessing import Pool, cpu_count
import functools
import core.prediction as pred
import core.ranking as rank
import core.training as train
from config import settings


def _parallel_train_predict(topic, vectorizer, qrel, features, scores, train_data, train_features, single_runs):

    n_feat = train.prep_train_feat(
        vectorizer,
        qrel,
        topic,
        train_data,
        train_features)

    model = train.train(train_features, topic, n_feat, model_type=settings.model_type)
    pred.predict(model, features, scores + '_' + str(topic))
    rank.rank(scores + '_' + str(topic), topic, single_runs)


def score(topics, vectorizer, qrel, features, scores, train_data, train_features, single_runs, num_cpu):
    cores = num_cpu
    p = Pool(cores)
    p.map(functools.partial(_parallel_train_predict,
                            vectorizer=vectorizer,
                            qrel=qrel,
                            features=features,
                            scores=scores,
                            train_data=train_data,
                            train_features=train_features,
                            single_runs=single_runs),
          topics)
