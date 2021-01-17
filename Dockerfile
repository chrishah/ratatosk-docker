FROM ubuntu:20.04

MAINTAINER <christoph.hahn@uni-graz.at>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
## preesed tzdata, update package index, upgrade packages and install needed software
RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
	echo "tzdata tzdata/Zones/Europe select Vienna" >> /tmp/preseed.txt; \
	debconf-set-selections /tmp/preseed.txt && \
	apt-get update && \
	apt-get install -y build-essential git tzdata \
		cmake zlib1g-dev

WORKDIR /usr/src

RUN git clone --recursive https://github.com/GuillaumeHolley/Ratatosk.git && \
	cd Ratatosk && \
	git reset --hard 74ca617afb20a7c24d73d20f2dcdf223db303496 && \
	mkdir build && cd build && \
	cmake -DMAX_KMER_SIZE=50 ../ && \
	make && make install

#add user (not really necessary)
RUN adduser --disabled-password --gecos '' ratatokuser
USER ratatokuser

WORKDIR /usr/home

CMD ["Ratatosk"]
