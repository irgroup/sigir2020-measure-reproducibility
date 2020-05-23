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

        # Extract single raw text document files from AQUAINT corpus
        dprep.raw_text_from_trec(path['robust05'],
                                 path['tmp'],
                                 path['robust05_raw'])
        dprep.clean_raw_text(path['robust05_raw'],
                             path['robust05_clean'])

        # Make union corpus
        if settings.robust_only:
            if settings.preprocess:
                corpora = [path['robust04_clean'], path['robust05_clean']]
                dprep.unify(path['union_robust0405'], corpora)
            else:
                corpora = [path['robust04_raw'], path['robust05_raw']]
                dprep.unify(path['union_robust0405_raw'], corpora)

        else:
            if settings.preprocess:
                corpora = [path['core18_clean'],
                           path['robust04_clean'],
                           path['robust05_clean']]
                dprep.unify(path['union_core18_robust0405'], corpora)
            else:
                corpora = [path['core18_raw'],
                           path['robust04_raw'],
                           path['robust05_raw']]
                dprep.unify(path['union_core18_robust0405_raw'], corpora)

    # Generate tfidf-vectorizer
    if settings.tfidf_vec:
        if settings.robust_only:
            if settings.preprocess:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust0405'],
                                                path['union_robust0405'])
            else:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust0405'],
                                                path['union_robust0405_raw'])
        else:
            if settings.preprocess:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust0405'],
                                                path['union_core18_robust0405'])
            else:
                tfidf_vec.dump_tfidf_vectorizer(file['vectorizer_core18_robust0405'],
                                                path['union_core18_robust0405_raw'])

    # Prepare tfidf-features
    if settings.prep_corpus_feature:
        if settings.preprocess:
            fprep.prepare_corpus_feature(file['vectorizer_core18_robust0405'],
                                         path['core18_clean'],
                                         file['feat_core18_robust0405'])
        else:
            fprep.prepare_corpus_feature(file['vectorizer_core18_robust0405'],
                                         path['core18_raw'],
                                         file['feat_core18_robust0405'])

    if settings.score:

        # Find intersecting topics
        qrel_files = [file['qrel_core18'], file['qrel_robust04'], file['qrel_robust05']]
        topics = util.find_inter_top(qrel_files[:2])

        # Merge qrel files from Robust04 and Robust05
        util.merge_qrels(qrel_files[1:], file['qrel_robust0405'])

        if topics is not None:

            if settings.robust_only:
                if settings.preprocess:
                    train_data = path['union_robust0405']
                else:
                    train_data = path['union_robust0405_raw']
            else:
                if settings.preprocess:
                    train_data = path['union_core18_robust0405']
                else:
                    train_data = path['union_core18_robust0405_raw']

            score.score(topics=topics,
                        vectorizer=file['vectorizer_core18_robust0405'],
                        qrel=file['qrel_robust0405'],
                        features=file['feat_core18_robust0405'],
                        scores=file['score_core18_robust0405'],
                        train_data=train_data,
                        train_features=path['train_feat'],
                        single_runs=path['single_runs'],
                        num_cpu=settings.num_cpu)

            complete_run_file = path['complete_run'] + 'repro_wcrobust0405_' + str(settings.num_con)
            evaluation.merge_single_topics(path['single_runs'], complete_run_file)
            evaluation.evaluate(file['trec_eval'], file['qrel_core18'], complete_run_file)
            util.clear_path([path['single_runs'], path['train_feat']])

        else:
            print("No intersecting topics")


if __name__ == '__main__':
    main()
