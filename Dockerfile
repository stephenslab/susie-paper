FROM debian:stretch-slim
MAINTAINER Gao Wang, gaow@uchicago.edu

WORKDIR /tmp

# Install dev libraries
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    gzip \
    bzip2 \
    ca-certificates \
    build-essential \
    gfortran \
    libgfortran-6-dev \
    libgomp1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log

# R, Python, SoS and DSC
ENV MINICONDA_VERSION 4.5.11
ENV PATH /opt/miniconda3/bin:$PATH
RUN curl https://repo.continuum.io/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -o MCON.sh \
    && /bin/bash MCON.sh -b -p /opt/miniconda3 \
    && ln -s /opt/miniconda3/etc/profile.d/conda.sh /etc/profile.d/conda.sh \
    && conda install matplotlib==3.0.2 seaborn==0.9.0 \
    && conda install -c conda-forge r-base==3.5.1 sos==0.17.7 dsc==0.3.1.2 rpy2==2.9.4 \
    && conda clean --all -tipsy && rm -rf /tmp/* $HOME/.cache
RUN pip install sos-notebook==0.17.3 jupyter_contrib_nbextensions==0.5.0 --no-cache-dir

# Packages for building and running susieR vignettes
RUN conda install -c conda-forge r-devtools r-testthat r-openssl r-reshape r-ggplot2 r-cowplot \
	r-profvis r-microbenchmark r-pkgdown r-dplyr r-stringr r-readr r-magrittr \
	r-matrixstats r-glmnet \
	libiconv && conda clean --all -tipsy && rm -rf /tmp/* $HOME/.cache
RUN ln -s /bin/tar /bin/gtar

# Large scale regression related tools for running some susieR vignettes
RUN R --slave -e "devtools::install_github('glmgen/genlasso')"
RUN R --slave -e "devtools::install_github('hazimehh/L0Learn')"

# Fine-mapping tools
RUN apt-get update && apt-get install -y --no-install-recommends libgsl-dev libgsl2 libatlas3-base liblapack-dev && apt-get clean
RUN curl -L https://github.com/fhormoz/caviar/tarball/743038a32ae66ea06ee599670cb7939fb80a923f -o caviar.tar.gz \
    && tar -zxvf caviar.tar.gz && cd fhormoz-caviar-*/CAVIAR-C++ && make \
    && mv CAVIAR eCAVIAR mupCAVIAR setCAVIAR /usr/local/bin && rm -rf /tmp/*

RUN curl -L https://github.com/xqwen/dap/tarball/ef11b263ae5e11b9e2e295757927877c03274095 -o dap.tar.gz \
    && tar -zxvf dap.tar.gz && cd xqwen-dap-*/dap_src && make && mv dap-g /usr/local/bin && rm -rf /tmp/*

RUN curl -L http://www.christianbenner.com/finemap_v1.1_x86_64.tgz -o finemap.tgz \
    && tar zxvf finemap.tgz && mv finemap_v1.1_x86_64/finemap_v1.1_x86_64 /usr/local/bin/finemap \
    && chmod +x /usr/local/bin/finemap && rm -rf /tmp/*

ENV SuSiE_VERSION 8a4f7177c0031255901083fa0f62555307acb6d9

# Supporting files
RUN curl -L https://raw.githubusercontent.com/stephenslab/susieR/${SuSiE_VERSION}/inst/code/finemap.R -o /usr/local/bin/finemap.R \
    && chmod +x /usr/local/bin/finemap.R

RUN curl -L https://raw.githubusercontent.com/stephenslab/susieR/${SuSiE_VERSION}/inst/code/caviar.R -o /usr/local/bin/caviar.R \
    && chmod +x /usr/local/bin/caviar.R

RUN curl -L https://raw.githubusercontent.com/stephenslab/susieR/${SuSiE_VERSION}/inst/code/dap-g.py -o /usr/local/bin/dap-g.py \
    && chmod +x /usr/local/bin/dap-g.py

# DSC R-utils
RUN R --slave -e "devtools::install_github('rstudio/reticulate')"
RUN R --slave -e "devtools::install_github('stephenslab/dsc@v0.3.1.2', subdir = 'dscrutils')"

# susieR 
RUN R --slave -e "devtools::install_github('stephenslab/susieR', ref = '"${SuSiE_VERSION}"')"

# Benchmark related
RUN R --slave -e "install.packages('abind', repos='http://cran.us.r-project.org')"


# Prevent local config / packages from being loaded
ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""
ENV R_LIBS_USER ' '

# In response to the following numpy error
# Error: Numpy + Intel(R) MKL: MKL_THREADING_LAYER=INTEL is incompatible with libgomp.so.1 library.
# Try to import numpy first or set the threading layer accordingly. Set NPY_MKL_FORCE_INTEL to force it.
ENV MKL_THREADING_LAYER GNU

CMD ["bash"]
