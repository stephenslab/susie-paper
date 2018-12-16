FROM debian:buster-slim

WORKDIR /tmp

# R & Python related
RUN apt-get update \
    && apt-get install -y r-base r-base-dev pandoc \
    && apt-get clean
RUN apt-get update \
    && apt-get install -y libatlas3-base libssl-dev libcurl4-openssl-dev libxml2-dev curl \
    && apt-get clean

RUN apt-get update \
    && apt-get install -y libgsl-dev libboost-iostreams-dev \
    && apt-get clean

RUN apt-get update \
    && apt-get install -y python3-pip libfreetype6-dev pkg-config \
    && apt-get clean
 
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

# Packages for building and running susieR vignettes
RUN R --slave -e "install.packages(c('pkgdown', 'devtools', 'testthat'), repos='http://cran.us.r-project.org')"
RUN R --slave -e "install.packages(c('reshape', 'ggplot2', 'cowplot'), repos='http://cran.us.r-project.org')"
RUN R --slave -e "install.packages(c('profvis', 'microbenchmark'), repos='http://cran.us.r-project.org')"
RUN R --slave -e "for (p in c('dplyr', 'stringr', 'readr', 'magrittr')) if (!require(p, character.only=TRUE)) install.packages(p, repos='http://cran.us.r-project.org')"
 
# Large scale regression related tools for running some susieR vignettes
RUN R --slave -e "install.packages('glmnet', repos='http://cran.us.r-project.org')"
RUN R --slave -e "devtools::install_github('glmgen/genlasso')"
RUN R --slave -e "devtools::install_github('hazimehh/L0Learn')"
RUN R --slave -e "install.packages('matrixStats', repos='http://cran.us.r-project.org')"

# SoS and DSC
RUN pip3 install sos==0.17.7 sos-notebook==0.17.2 dsc==0.3.1.2 rpy2==2.9.4 tzlocal --no-cache-dir
RUN pip3 install jupyter_contrib_nbextensions==0.2.8 jupyter_contrib_core==0.3.1 --no-cache-dir
RUN R --slave -e "devtools::install_github('stephenslab/dsc@v0.3.1.2', subdir = 'dscrutils')"

# Python packages for making plots
RUN pip3 install matplotlib==3.0.2 seaborn==0.9.0 --no-cache-dir

# susieR 
RUN R --slave -e "devtools::install_github('stephenslab/susieR', ref = '"${SuSiE_VERSION}"')"

# Prevent local config / packages from being loaded
ENV R_ENVIRON_USER ""
ENV R_PROFILE_USER ""
ENV R_LIBS_USER ' '

CMD ["bash"]
