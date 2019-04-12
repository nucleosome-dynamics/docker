FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8
RUN apt-get update && apt-get -y install \
tcsh software-properties-common git libcurl4-gnutls-dev libxml2-dev vim wget 
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9  
RUN gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" | tee -a /etc/apt/sources.list
RUN apt update && apt-get  install -y r-base apt-transport-https libcurl4-openssl-dev libxml2-dev
RUN mkdir /home/NucleosomeDynamics
WORKDIR /home/NucleosomeDynamics
COPY install_nucleR.R .
RUN /usr/bin/Rscript install_nucleR.R 
RUN git clone https://github.com/nucleosome-dynamics/NucDyn.git NucDyn
RUN tar -czvf  NucDyn_0.99.0.tar.gz NucDyn
RUN R CMD INSTALL NucDyn_0.99.0.tar.gz
RUN git clone https://github.com/nucleosome-dynamics/nucleosome_dynamics.git NucleosomeDynamics
RUN mkdir NucleosomeDynamics/wig_utils
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/wigToBigWig -O NucleosomeDynamics/wig_utils/wigToBigWig
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bigWigToWig  -O NucleosomeDynamics/wig_utils/bigWigToWig
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/fetchChromSizes -O NucleosomeDynamics/wig_utils/fetchChromSizes
ENV PATH="/home/NucleosomeDynamics/NucleosomeDynamics/wig_utils/:${PATH}"
RUN chmod a+x NucleosomeDynamics/wig_utils/*
COPY dependencies_NucDyn.R .
RUN /usr/bin/Rscript dependencies_NucDyn.R 
COPY test/scripts/wf-test.sh .
COPY runNuclDyn . 
COPY help/* help/
RUN chmod +x runNuclDyn
ENTRYPOINT ["/home/NucleosomeDynamics/runNuclDyn"]
RUN adduser -uid 99990 --home /home/NucleosomeDynamics --no-create-home nucdyn
USER nucdyn:nucdyn
#
############# Metadata ###################
LABEL base.image="ubuntu:18.04"
LABEL software="NucleosomeDynamics"
LABEL software.version="Contains R 3.5.0  NucDyn 1.0, NucleR 2.2.0"
LABEL version="v1.0"
LABEL about.summary="R Based package for Nucleosome positioning analysis using MNase seq data"
LABEL about.home="http://mmb.irbbarcelona.org/NucleosomeDynamics"
LABEL about.license="APACHE2"
LABEL maintainer="Josep Ll. Gelpi <gelpi@ub.edu>"
