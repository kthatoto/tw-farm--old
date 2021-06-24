FROM ruby:2.7.3
COPY . /root
WORKDIR /root

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install libsqlite3-dev
RUN apt-get install sqlite3
RUN bundle install

RUN echo "alias termworld='bundle exec termworld'" >> ./.bashrc
ENTRYPOINT bash
