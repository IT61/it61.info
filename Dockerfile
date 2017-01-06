FROM ruby:2.3.3

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.

ENV app /app
ENV BUNDLE_PATH /gems

RUN mkdir -p $app
WORKDIR $app

# Copy the main application.
ADD . $app

EXPOSE 3000

CMD rails s -b 0.0.0.0
