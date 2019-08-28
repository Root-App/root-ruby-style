FROM ruby:2.5.5

RUN mkdir /root-ruby-style
WORKDIR /root-ruby-style

COPY Gemfile Gemfile.lock root-ruby-style.gemspec /root-ruby-style/
RUN bundle install

COPY . /root-ruby-style
