Note: to run these experiments we used Matlab, version: 9.6.0.1214997 (R2019a) Update 6.

We used Matters (http://matters.dei.unipd.it/) a software toolkit written in Matlab for information retrieval evaluation.

Before running the following scripts you need to set the correct path to the folder containing matters.

You also need to set the correct paths to folders containing runs and measures scores.

Functions:
- trim_runs.m function to trim a run at a given cut-off;
- tau_runs.m function to compute Kendall's tau union between two runs;
- discountedCumulatedGainTR.m function to compute nDCG with the same configuration as trec_eval;
- rmse_replicability.m function to compute RMSE between two runs for any effectiveness measure;
- paired_ttest_replicability.m function to compute a paired t-test for the replicability runs;
- effect_ratio_replicability.m function to compute Effect Ratio (ER) for the replicability case;
- effect_ratio_reproducibility.m function to compute Effect Ratio (ER) for the reproducibility case;
- unpaired_ttest_reproducibility.m function to compute an unpaired t-test for the reproducibility case.

Replicability Scripts:
- replicability_eval_SIGIR2020_final.m script to compute measures scores and Kendall's tau (generates the csv files in ./results/measures);
- replicability_summary_table_SIGIR2020_final.m script to generate Table 1 in the paper and Table 1 in the online appendix;
- replicability_plot_SIGIR2020.m script to generate Figure 1a and Figure 1b in the paper and Figure 1a and Figure 1b in the online appendix;
- replicability_effectratio_SIGIR2020_final.m script to generate Table 2 (left side) in the paper;
- replicability_relative_improvement_plot_SIGIR2020.m script to generate Figure 2a and Figure 2b in the paper, and Figure 2a and Figure 2b in the online appendix;
- replicability_measures_correlation_SIGIR2020_final.m script to generate Table 4 in the paper.

Reproducibility scripts:
- reproducibility_eval_SIGIR2020_final.m script to compute measures scores for replicated runs (generates the csv files in ./results/measures_rpd);
- reproducibility_summary_table_SIGIR2020_final.m script to generate Table 2 (right side) in the paper;
- reproducibility_pvalue_table_SIGIR2020_final.m script to generate Table 3 in the paper and Table 2 in the online appendix;
- reproducibility_pvalue_SIGIR2020_test_meaningfulness.m script to generate Table 3 in the online appendix;
- reproducibility_relative_improvement_plot_SIGIR2020.m script to generate Figure 3a and Figure 3b in the paper and Figure 3a and Figure 3b in the online appendix; 
- reproducibility_measures_correlation_SIGIR2020_final.m script to generate Table 5 in the paper.