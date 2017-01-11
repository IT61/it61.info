FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

ENV app /app
ENV BUNDLE_PATH /gems

RUN mkdir -p $app
WORKDIR $app

# Copy the main application.
ADD . $app

EXPOSE 3000

CMD rails s -b 0.0.0.0
