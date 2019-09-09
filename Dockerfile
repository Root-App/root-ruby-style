FROM ruby:2.6.3

RUN gem install bundler --version 2.0.2
RUN mkdir /root-ruby-style
WORKDIR /root-ruby-style

COPY Gemfile Gemfile.lock root-ruby-style.gemspec /root-ruby-style/
RUN bundle install

COPY . /root-ruby-style
