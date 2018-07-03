FROM ubuntu:16.04
RUN apt-get update && apt-get -y install \
tcsh software-properties-common git libcurl4-gnutls-dev libxml2-dev vim 
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
#RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu xenial-cran35/" | tee -a /etc/apt/sources.list
#RUN apt-get install -y apt-transport-https
RUN apt update && apt-get  install -y r-base  
RUN mkdir /home/NucleosomeDynamics
WORKDIR /home/NucleosomeDynamics
COPY setRlibs.R .
RUN /usr/bin/Rscript setRlibs.R 
COPY NucDyn_0.1.tar.gz .
COPY nucleR_2.2.0.tar.gz .
RUN R CMD INSTALL nucleR_2.2.0.tar.gz
RUN R CMD INSTALL NucDyn_0.1.tar.gz
RUN git clone http://mmb.irbbarcelona.org/gitlab/NuclDynamics/distpkg.git NuclDyn
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
LABEL base.image="ubuntu:16.04"
LABEL software="NucleosomeDynamics"
LABEL software.version="Contains R 3.2.3  NucDyn 0.1, NucleR 2.2.0"
LABEL version="0.2"
LABEL about.summary="R Based package for Nucleosome positioning analysis using MNase seq data"
LABEL about.home="http://mmb.irbbarcelona.org/NucleosomeDynamics"
LABEL about.license=""
LABEL maintainer="Josep Ll. Gelpi <gelpi@ub.edu>"





