# Code & data accompanying SuSiE manuscript (Wang et al, 2018)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.2368676.svg)](https://doi.org/10.5281/zenodo.2368676)

This repository contains code and data resources to accompany our
research paper:

> G Wang, A K Sarkar, P Carbonetto and M Stephens. A simple new approach to variable selection in regression, with application to genetic fine-mapping. [bioRxiv](https://www.biorxiv.org/content/10.1101/501114v1) doi:10.1101/501114. 



For full details, please view the repository website at: https://stephenslab.github.io/susie-paper .

## Main results

[**A demonstration of SuSiE's motivations**](https://stephenslab.github.io/susie-paper/manuscript_results/motivating_example.html)<br>
&nbsp; &nbsp;This document explains with toy example illustration the unique type of inference SuSiE is interested in.

[**A pedagogical example of fine-mapping problem**](https://stephenslab.github.io/susie-paper/manuscript_results/pedagogical_example.html)<br>
&nbsp; &nbsp;Here we demonstrate with simulated data a setting of fine-mapping problem where it is clearly problematic to run forward stagewise selection, but SuSiE's Iterative Bayesian Stepwise Selection procedure can correctly identify the causal signals and compute posterior inclusion probability (posterior mean from a variational approximation to the posterior distribution). We also compared SuSiE results with other Bayesian sparse regression approach, and demonstrate that SuSiE is robust to prior choice and provide information more relevant to fine-mapping applications that other methods do not provide.

[**Selective inference for a toy example**](https://stephenslab.github.io/susie-paper/manuscript_results/selective_inference_toy.html)<br>
&nbsp; &nbsp;Here we investigate "selective inference" in the toy example of [Wang et al (2018)](https://www.biorxiv.org/content/10.1101/501114v1). We show that the approach will sometimes select the wrong variables -- which is inevitable in cases where variables are perfectly correlated -- and then assign them highly significant $p$ values. This is because even though the wrong variables are selected, their coefficients within the wrong model can be estimated precisely.

[**Numerical Comparisons**](https://stephenslab.github.io/susie-paper/manuscript_results/numerical_results.html)<br>
&nbsp; &nbsp;This page contains information to reproduce the numerical comparisons in SuSiE manuscript.

[**Application to change point detection problem**](https://stephenslab.github.io/susie-paper/manuscript_results/changepoint_example.html)<br>
&nbsp; &nbsp;Although we developed SuSiE primarily with the goal of performing variable selection in highly sparse settings -- and, in particular, for genetic fine-mapping -- the approach also has considerable potential for application to other large-scale regression problems. Here we briefly illustrate this potential by applying it to a non-parametric regression problem that at first sight seems to be ill-suited to our approach.

[**Splicing QTL analysis: application to Li et al 2016**](https://stephenslab.github.io/susie-paper/manuscript_results/Li_2016_splice_QTL.html)<br>
&nbsp; &nbsp;In Li et al 2016 the authors systematically analyzed genetic effects (SNPs) on various molecular phenotypes of gene regulation, from the chromatin state through protein function.
