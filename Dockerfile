FROM ubuntu:16.04

ARG port

ENV REFRESHED_AT=2018-08-16 \
    LANG=en_US.UTF-8 \
    HOME=/opt/build \
    TERM=xterm \
    PORT=$port

WORKDIR /opt/build

ADD ./bin/build /opt/build/bin/build

RUN \
  apt-get update -y && \
  apt-get install -y git wget vim locales && \
  apt-get install make && \
  locale-gen en_US.UTF-8 && \
  wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  rm erlang-solutions_1.0_all.deb && \
  apt-get update -y && \
  apt-get install -y erlang elixir

CMD ["/bin/build"]
