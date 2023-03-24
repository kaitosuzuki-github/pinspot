FROM ruby:3.1.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /pinspot
WORKDIR /pinspot
COPY Gemfile /pinspot/Gemfile
COPY Gemfile.lock /pinspot/Gemfile.lock
RUN bundle install
COPY . /pinspot
