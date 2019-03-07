FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install \
tcsh software-properties-common git libcurl4-gnutls-dev libxml2-dev vim 
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9  
RUN gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add -
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" | tee -a /etc/apt/sources.list
RUN apt update && apt-get  install -y r-base apt-transport-https libcurl4-openssl-dev libxml2-dev
RUN mkdir /home/NucleosomeDynamics
WORKDIR /home/NucleosomeDynamics
COPY setRlibs.R .
RUN /usr/bin/Rscript setRlibs.R 
COPY nucleR_2.2.0.tar.gz .
RUN R CMD INSTALL nucleR_2.2.0.tar.gz
RUN git clone http://mmb.irbbarcelona.org/gitlab/NuclDynamics/NucleosomeDynamics_core.git NucDyn
RUN tar -czvf  NucDyn.tar.gz NucDyn 
RUN R CMD INSTALL NucDyn.tar.gz
RUN git clone http://mmb.irbbarcelona.org/gitlab/NuclDynamics/nucleServ.git NuclDyn
COPY setRlibs2.R .
RUN /usr/bin/Rscript setRlibs2.R 
RUN mkdir /public_dir
RUN mkdir /data_dir
VOLUME ['/public_dir','/data_dir']
COPY wf-test.sh .
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
LABEL version="1.0"
LABEL about.summary="R Based package for Nucleosome positioning analysis using MNase seq data"
LABEL about.home="http://mmb.irbbarcelona.org/NucleosomeDynamics"
LABEL about.license=""
LABEL maintainer="Josep Ll. Gelpi <gelpi@ub.edu>"
