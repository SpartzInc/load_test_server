# LoadTestServer

LoadTestServer is a Rails app that allows you to create, run, and store results for load tests.

We added Docker support for this, to help ease any differences in platforms.  This Rails app can operate
with or without Docker.  Just make sure to provide the correct environment variables when trying to run without.
  
## Initial Login

This gets added when running rake db:setup_initial.  Will only add if there are no users in the database,
so this can be run at any time afterwards too.

Username: admin@admin.com

Password: test1234

## Features

1. Linear loading of users up and down, with the ability to create complicated scenarios.
2. Create custom user scenarios by GET/POST against web endpoints with the ability to do params too
3. Store AWS EC2/RDS instances CloudWatch metric data while load testing is occurring
4. View test results and metrics data

##Docker Basic Installation

1. Install Virtual Box https://www.virtualbox.org/wiki/Downloads
2. Install Docker Toolbox https://www.docker.com/docker-toolbox
3. Upgrade docker-compose to min 1.5, because we are using environment variables and need 1.5 > to interpolate that
  * https://github.com/docker/compose/releases/tag/1.5.0rc1
  * URL includes two commands to curl and install the new docker-compose

##LoadTestServer Docker Installation

1. docker-machine create --driver virtualbox lts
  * Specifying VirtualBox, only tested with that driver on Mac OSX
2. docker-machine env lts
  * Only shows the environment variables, next command will save them for future steps
3. eval "$(docker-machine env lts)"
  * Stores env variables in current shell session.  Will need to do this each time you are
  interacting with a specific virtual machine
4. source docker_run.sh
  * This will the initial run command and start the docker container, which will update and build if needed
5. Edit /etc/hosts and add IP address of the docker container with the host "dev.loadtestserver"
  * If you change the name of the virtual host in the env file(s) then update your entry in the /etc/hosts file
6. You should be able to access LoadTestServer now
  * I have noticed timeouts on initial starting once and awhile.  Usually occurs because it is
  generating assets on request.

##Docker Important Commands

* docker-machine ls
  * Lists machines that are currently running/stopped/etc...
* docker-machine env NAME_OF_MACHINE
  * Replace NAME_OF_MACHINE with the name given in docker-machine ls
* eval "$(docker-machine env NAME_OF_MACHINE)"
  * Adds environment variables to shell session so you are using the correct virtual machine
* docker-compose up
  * Builds/updates/runs docker container using the docker-compose.yml.
* docker-machine stop NAME_OF_DOCKER_MACHINE
  * Stops machine
* docker-machine rm NAME_OF_DOCKER_MACHINE
  * Removes machine
  
## Environment Variables

1. LTS_DATABASE_HOST_DEV
  * Sets development MySQL host
2. LTS_DATABASE_USER_DEV
  * Sets development MySQL user
3. LTS_DATABASE_PASS_DEV
  * Sets development MySQL pass
4. LTS_DATABASE_HOST_PROD
  * Sets production MySQL host
5. LTS_DATABASE_USER_PROD
  * Sets production MySQL user
6. LTS_DATABASE_PASS_PROD
  * Sets production MySQL pass
7. LTS_SECRET_KEY_BASE
  * Sets Rails key base
8. LTS_DEVISE_SECRET_KEY
  * Sets Devise secret key
9. LTS_ENCRYPTION_KEY
  * Sets Symmetric Encryption private key
10: LTS_VIRTUAL_HOST
  * Sets virtual host of box, set your /etc/hosts file to that along with the ip of your docker container
11: LTS_RAILS_ENV
  * Sets rails environment
  
#Contributors

1. Mike Blatter
2. Erik Stockmeier