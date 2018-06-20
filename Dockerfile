FROM ubuntu:16.04
RUN apt-get update && apt-get -y install \
tcsh software-properties-common git libcurl4-gnutls-dev libxml2-dev \
r-base  
RUN mkdir /home/NucleosomeDynamics
WORKDIR /home/NucleosomeDynamics
COPY setRlibs.R .
RUN /usr/bin/Rscript setRlibs.R 
COPY NucDyn_0.1.tar.gz .
COPY nucleR_2.13.0.tar.gz .
RUN R CMD INSTALL nucleR_2.13.0.tar.gz
RUN R CMD INSTALL NucDyn_0.1.tar.gz
RUN git clone -b docker http://mmb.irbbarcelona.org/gitlab/NuclDynamics/nucleServ.git NuclDyn
RUN mkdir /public_dir
RUN mkdir /data_dir
VOLUME ['/public_dir','/data_dir']
RUN apt-get install csh
COPY wf-test.sh .
COPY runNuclDyn .
RUN apt-get install -y vim
RUN chmod +x runNuclDyn
RUN adduser nucdyn
USER nucdyn:nucdyn





