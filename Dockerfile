FROM ruby:2.7.3
COPY . /root
WORKDIR /root
RUN bundle install

RUN echo "alias termworld='bundle exec termworld'" >> ./.bashrc
ENTRYPOINT bash
