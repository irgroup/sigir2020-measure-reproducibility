# How to Measure the Reproducibility of System-oriented IR Experiments

This repository contains the accompanying code, dataset and online appendix of:   

> **Timo Breuer**, **Nicola Ferro**, **Norbert Fuhr**, **Maria Maistro**, **Tetsuya Sakai**, **Philipp Schaer**, and **Ian Soboroff**. 2020. How to Measure the Reproducibility of System-oriented IR Experiments. *In Proceedings of the 43rd International ACM SIGIR Conference on Research and Development in Information Retrieval (SIGIR’20)*.

## Abstract
Replicability and reproducibility of experimental results are primary concerns in all the areas of science and IR is not an exception. Besides the problem of moving the field towards more reproducible experimental practices and protocols, we also face a severe methodological issue: we do not have any means to assess when reproduced is reproduced. Moreover, we lack any reproducibility-oriented dataset, which would allow us to develop such methods.

To address these issues, we compare several measures to objectively quantify to what extent we have replicated or reproduced a system-oriented IR experiment. These measures operate at different levels of granularity, from the fine-grained comparison of ranked lists, to the more general comparison of the obtained effects and significant differences. Moreover, we also develop a reproducibility-oriented dataset, which allows us to validate our measures and which can also be used to develop future measures.

## Setup 
1. Install requirements with pip: 
   ```
   pip install -r requirements.txt
   ```
2. Download English stopwords for nltk:
   ```
   python -m nltk.downloader stopwords
   ```   
3. Clone [trec_eval](https://github.com/usnistgov/trec_eval) and compile it in this directory:
    ```
    git clone https://github.com/usnistgov/trec_eval.git && make -C trec_eval
    ```
4. Edit `config/config.py` by adding the path of the four test collections to the parameters `robust04`, `robust05`, `core17` and `core18`.

5. Specify one of the 50 run constellations with the help of `config/settings.py`. Set the parameter `num_con` to the appropriate number of the constellation. If the preprocessing has already been done for a previous run, it can be omitted by setting the parameter `data_prep` to `False`. 

6. Run the commands below for producing the respective run.
  
  | | Replicability | Reproducibility |
  |---|---|---|
  | WCRobust04 | `python -m replicability.wcrobust04` | `python -m reproducibility.wcrobust04` | 
  | WCRobust0405 | `python -m replicability.wcrobust0405` | `python -m reproducibility.wcrobust0405` |

## Workflow 

[![](https://mermaid.ink/img/eyJjb2RlIjoiZ3JhcGggVERcbiAgQVtDb3JlMTcvMThdIC0tPnxwcmVwcm9jZXNzfCBCW05vcm1hbGl6ZWQgdGV4dCA8YnI-Q29yZTE3LzE4XVxuICBaW1JvYnVzdDA0LzA1XSAtLT58cHJlcHJvY2Vzc3wgWVtOb3JtYWxpemVkIHRleHQgPGJyPlJvYnVzdDA0LzA1XVxuICBKW3FyZWwgPGJyPlJvYnVzdDA0LzA1XSAtLT58bGFiZWx8IEtcbiAgQiAtLT4gR1xuICBZIC0tPiBDXG4gIFkgLS0-IEdcbiAgQiAtLT4gQ1tVbmlvbiBjb3JwdXNdXG4gIEMgLS0-IEdbVGZpZGZWZWN0b3JpemVyXVxuICBHIC0tPiBIW3RmaWRmLWZlYXR1cmVzIDxicj5Db3JlMTcvMThdXG4gIEcgLS0-IElbdGZpZGYtZmVhdHVyZXMgPGJyPlJvYnVzdDA0LzA1XVxuICBJIC0tPnx0cmFpbnwgS1tMb2dpc3RpYyByZWdyZXNzaW9uXVxuICBLIC0tPnxzY29yZXwgSFxuICBIIC0tPiBNW1JhbmtpbmddXG4gIE0gLS0-IFAoRXZhbHVhdGlvbilcbiAgTltxcmVsIDxicj5Db3JlMTcvMThdIC0tPiBQXG4gIE9bdHJlY19ldmFsXSAtLT4gUFxuXG5cblxuXHRcdCIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoiZ3JhcGggVERcbiAgQVtDb3JlMTcvMThdIC0tPnxwcmVwcm9jZXNzfCBCW05vcm1hbGl6ZWQgdGV4dCA8YnI-Q29yZTE3LzE4XVxuICBaW1JvYnVzdDA0LzA1XSAtLT58cHJlcHJvY2Vzc3wgWVtOb3JtYWxpemVkIHRleHQgPGJyPlJvYnVzdDA0LzA1XVxuICBKW3FyZWwgPGJyPlJvYnVzdDA0LzA1XSAtLT58bGFiZWx8IEtcbiAgQiAtLT4gR1xuICBZIC0tPiBDXG4gIFkgLS0-IEdcbiAgQiAtLT4gQ1tVbmlvbiBjb3JwdXNdXG4gIEMgLS0-IEdbVGZpZGZWZWN0b3JpemVyXVxuICBHIC0tPiBIW3RmaWRmLWZlYXR1cmVzIDxicj5Db3JlMTcvMThdXG4gIEcgLS0-IElbdGZpZGYtZmVhdHVyZXMgPGJyPlJvYnVzdDA0LzA1XVxuICBJIC0tPnx0cmFpbnwgS1tMb2dpc3RpYyByZWdyZXNzaW9uXVxuICBLIC0tPnxzY29yZXwgSFxuICBIIC0tPiBNW1JhbmtpbmddXG4gIE0gLS0-IFAoRXZhbHVhdGlvbilcbiAgTltxcmVsIDxicj5Db3JlMTcvMThdIC0tPiBQXG4gIE9bdHJlY19ldmFsXSAtLT4gUFxuXG5cblxuXHRcdCIsIm1lcm1haWQiOnsidGhlbWUiOiJkZWZhdWx0In0sInVwZGF0ZUVkaXRvciI6ZmFsc2V9)

## Mapping run names to constellation numbers 

| run name | constellation number |
| --- | --- |
| rpl/rpd_tf_1 | 45 |
| rpl/rpd_tf_2 | 46 |
| rpl/rpd_tf_3 | 47 |
| rpl/rpd_tf_4 | 48 |
| rpl/rpd_tf_5 | 49 |
| rpl/rpd_df_1 | 14 |
| rpl/rpd_df_2 | 15 |
| rpl/rpd_df_3 | 16 |
| rpl/rpd_df_4 | 17 |
| rpl/rpd_df_5 | 18 |
| rpl/rpd_tol_1 | 39 |
| rpl/rpd_tol_2 | 38 |
| rpl/rpd_tol_3 | 37 |
| rpl/rpd_tol_4 | 36 |
| rpl/rpd_tol_5 | 35 |
| rpl/rpd_C_1 | 44 |
| rpl/rpd_C_2 | 43 |
| rpl/rpd_C_3 | 42 |
| rpl/rpd_C_4 | 41 |
| rpl/rpd_C_5 | 40 |


## Evaluation

For the evaluation script you need Matlab and [Matters](http://matters.dei.unipd.it/).

Alternatively some evlautaion measures are already pre-computed and stored in csv files: `evaluation/matlab/results`.