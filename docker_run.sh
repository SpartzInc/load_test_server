#!/usr/bin/env bash

source docker.env

docker-compose run web bundle exec rake db:setup_initial && bundle exec rails generate symmetric_encryption:new_keys production
docker-compose up