import core.data_preparation as dprep
import core.evaluation as evaluation
import core.feature_preparation as fprep
import core.tfidf_vectorization as tfidf_vec
import core.util as util
import core.scoring as score

from config.config import path, file
from config import settings


def main():

    if settings.clean_dir:
        # Delete old artifacts
        util.clear_path([path['single_runs'],
                         path['train_feat'],
                         path['score']])
        # Setup directories
        util.check_path(settings.paths_to_check)
        # Delete old shelve with features, if existent
        util.delete_shelve(file['feat_core18_robust04'])

    if settings.data_prep:
        # Extract single raw text document files from Washington Post JSON-lines file
        dprep.raw_text_from_wapo(file['core18'],
                                 path['core18_raw'])
        dprep.clean_raw_text(path['core18_raw'],
                             path['core18_clean'],
                             wapo=True)

        # Extract single raw text document files from TREC Disks 4 & 5
        dprep.raw_text_from_trec(path['robust04'],
                                 path['tmp'],
                                 path['robust04_raw'])
        dprep.clean_raw_text(path['robust04_raw'],
                             path['robust04_clean'])

        # Make union corpus
        if not settings.robust_only:
            if settings.preprocess:
                corpora = [path['core18_clean'], path['robust04_clean']]
                dprep.unify(path['union_core18_robust04'], corpora)
            else:
                corpora = [path['core18_raw'], path['robust04_raw']]
                dprep.unify(path['union_core18_robust04_raw'], corpora)

    # Generate tfidf-vectorizer
    if settings.tfidf_vec:
        if settings.robust_only:
            if settings.preprocess:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust04'],
                                                path['robust04_clean'])
            else:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust04'],
                                                path['robust04_raw'])
        else:
            if settings.preprocess:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust04'],
                                                path['union_core18_robust04'])
            else:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust04'],
                                                path['union_core18_robust04_raw'])

    # Prepare tfidf-features
    if settings.prep_corpus_feature:
        if settings.preprocess:
            fprep.prepare_corpus_feature(file['vectorizer_core18_robust04'],
                                         path['core18_clean'],
                                         file['score_core18_robust04'])
        else:
            fprep.prepare_corpus_feature(file['vectorizer_core18_robust04'],
                                         path['core18_raw'],
                                         file['score_core18_robust04'])

    if settings.score:

        # Find intersecting topics
        qrel_files = [file['qrel_core18'], file['qrel_robust04']]
        topics = util.find_inter_top(qrel_files)

        if topics is not None:

            if settings.robust_only:
                if settings.preprocess:
                    train_data = path['robust04_clean']
                else:
                    train_data = path['robust04_raw']
            else:
                if settings.preprocess:
                    train_data = path['union_core18_robust04']
                else:
                    train_data = path['union_core18_robust04_raw']

            score.score(topics=topics,
                        vectorizer=file['vectorizer_core18_robust04'],
                        qrel=file['qrel_robust04'],
                        features=file['feat_core18_robust04'],
                        scores=file['score_core18_robust04'],
                        train_data=train_data,
                        train_features=path['train_feat'],
                        single_runs=path['single_runs'],
                        num_cpu=settings.num_cpu)

            complete_run_file = path['complete_run'] + 'repro_wcrobust04_' + str(settings.num_con)
            evaluation.merge_single_topics(path['single_runs'], complete_run_file)
            evaluation.evaluate(file['trec_eval'], file['qrel_core18'], complete_run_file)
            util.clear_path([path['single_runs'], path['train_feat']])

        else:
            print("No intersecting topics")


if __name__ == '__main__':
    main()
