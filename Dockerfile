FROM ruby:2.6.7
COPY . /root
WORKDIR /root
RUN bundle install

RUN echo "alias termworld='bundle exec termworld'" >> ./.bashrc
ENTRYPOINT bash
