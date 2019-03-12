# Dockerfile # Mapknitter
# https://github.com/publiclab/mapknitter/

FROM debian:buster
LABEL This image deploys Mapknitter!

# Set correct environment variables.
RUN mkdir -p /app
ENV HOME /root

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  bundler ruby-rmagick libfreeimage3 \
  libfreeimage-dev ruby-dev curl \
  libssl-dev zip nodejs gdal-bin
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y npm
RUN npm install -g bower


# Install bundle of gems
WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN bundle install

# Add the Rails app
WORKDIR /app
ADD . /app
RUN bower install --allow-root
