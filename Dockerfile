FROM ruby:2.5.1

RUN mkdir /root-infrastructure
WORKDIR /root-infrastructure

COPY Gemfile Gemfile.lock root-ruby-style.gemspec /root-infrastructure/
RUN bundle install

COPY . /root-infrastructure
