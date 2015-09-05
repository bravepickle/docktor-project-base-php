#!/bin/sh
# Deploy docker master app
# run as root

# Try installing docker if not installed yet
echo Setup Docker
docker --version || (\
    apt-get update && \
    apt-get install wget -y && \
    (wget -qO- https://get.docker.com/ | sh) && \
    usermod -aG docker vagrant)

# Install puppet
echo Setup Puppet
puppet --version || (\
    cd /tmp && \
    wget https://apt.puppetlabs.com/puppetlabs-release-precise.deb && \
    dpkg -i puppetlabs-release-precise.deb && \
    apt-get update)

echo Setup Docker Compose
docker-compose --version || (\
    curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose)

echo Setup SupervisorD
supervisor --version || (apt-get install supervisor -y)