FROM archlinux

ENV JUDGE_NAME='<JUDGE_NAME>'
ENV JUDGE_KEY='<JUDGE_KEY>'
ENV JUDGE_SITE='<JUDGE_SITE>'

RUN pacman-key --init && \
    pacman-key --populate && \
    useradd -r -m judge && \
    pacman -Syu --noconfirm python python2 python-pip nano vim git cython && \
    locale-gen

# Extra language configurations. Choose what you want.

RUN pacman -Syu

RUN pacman -Syu --noconfirm \
      ghc lua clang nodejs coffeescript scala crystal rust \
      pypy pypy3 racket ruby2.6 swi-prolog gcc-ada gnucobol dmd gcc-fortran \
      dart go groovy fpc php ocaml jdk8-openjdk jdk11-openjdk

RUN pacman -Syu --noconfirm wget

# julia installation with pacman doesn't work right now ... investigate it later
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.2-linux-x86_64.tar.gz
RUN tar -xvzf julia-1.5.2-linux-x86_64.tar.gz
RUN cp -r julia-1.5.2 /opt/
RUN ln -s /opt/julia-1.5.2/bin/julia /usr/local/bin/julia


WORKDIR /judge

RUN git clone https://github.com/schoj/judge /judge --depth=1 && \
    pip install cython && \
    python setup.py install && \
    mkdir /problems

ADD startup.sh /

CMD sh /startup.sh
