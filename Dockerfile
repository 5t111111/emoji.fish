FROM ruby:2.4.1

RUN gem i bundler --no-document

RUN gem update --system

WORKDIR /emoji.fish
