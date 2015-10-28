FROM ubuntu:trusty

RUN apt-get update && \
    apt-get install -qy software-properties-common

RUN apt-add-repository -y ppa:brightbox/ruby-ng
RUN apt-get update && apt-get upgrade -y

# Ruby and dependencies
RUN apt-get install -qy curl nodejs libmysqlclient-dev libsqlite3-dev build-essential \
                        ruby2.1 ruby2.1-dev
RUN gem install bundler --no-ri --no-rdoc

# Cache bundle install
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# Add rails project to project directory
ADD ./ /rails

# set WORKDIR
WORKDIR /rails

RUN bundle exec rake assets:precompile

#Create directory if needed
RUN mkdir -p /etc/rails/keys

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Publish port 8080
EXPOSE 8080