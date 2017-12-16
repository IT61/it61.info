FROM ruby:2.4.2

ENV APP_PATH=/app \
    BUNDLE_PATH=/gems

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

# Copy the main application.
ADD . $APP_PATH

EXPOSE 3000

CMD ./bin/rails server -b 0.0.0.0
