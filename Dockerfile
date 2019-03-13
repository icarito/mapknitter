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
  libfreeimage-dev zip nodejs gdal-bin \
  curl g++ gcc autoconf automake bison \
  libc6-dev libffi-dev libgdbm-dev \
  libncurses5-dev libsqlite3-dev libtool \
  libyaml-dev make pkg-config sqlite3 \
  zlib1g-dev libgmp-dev libreadline-dev libssl-dev \
  procps

# Ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && curl -sSL https://get.rvm.io | bash -s stable && usermod -a -G rvm root
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && rvm install 2.4.4 && rvm use 2.4.4 --default"
# The entry point here is an initialization process, 
# it will be used as arguments for e.g.
# `docker run` command 
ENTRYPOINT ["/bin/bash", "-l", "-c"]

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
