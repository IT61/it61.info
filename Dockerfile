FROM ruby:2.4.3-alpine3.7

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh \
    build-base nodejs tzdata postgresql postgresql-dev python

RUN apk update \
  && apk add curl bash binutils tar gnupg \
  && rm -rf /var/cache/apk/* \
  && /bin/bash \
  && touch ~/.bashrc \
  && curl -o- -L https://yarnpkg.com/install.sh | bash \
  && apk del curl tar binutils

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5 --without development test

ENV RAILS_ENV production
ENV NODE_ENV production
ENV RACK_ENV production

ENV RAILS_SERVE_STATIC_FILES 1

ARG SECRET_KEY_BASE
ENV SECRET_KEY_BASE $SECRET_KEY_BASE

COPY . ./
RUN rails assets:precompile
RUN rails db:migrate

EXPOSE 3000
