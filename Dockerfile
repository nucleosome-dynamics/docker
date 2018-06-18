FROM ubuntu:16.04
RUN apt-get update && apt-get -y install \
software-properties-common git libcurl4-gnutls-dev libxml2-dev \
r-base  
RUN mkdir /home/NucleosomeDynamics
WORKDIR /home/NucleosomeDynamics
COPY . .
RUN /usr/bin/Rscript setRlibs.R
RUN R CMD INSTALL NucDyn_0.1.tar.gz
RUN git clone http://mmb.irbbarcelona.org/gitlab/MuG/nucleServ.git NuclDyn
RUN mkdir /public_dir
RUN mkdir /data_dir
VOLUME ['/public_dir','/data_dir']
#RUN adduser nucdyn
#USER nucdyn:nucdyn



