FROM debian

ARG env_host
ARG env_port

# Copy modules
COPY . /tmp
COPY ./services /tmp/services
COPY ./env /tmp/env

# Create env variables based on argument
RUN echo "export host=$env_host" >> /tmp/env/env_global.sh
RUN echo "export port=$env_port" >> /tmp/env/env_global.sh

# Crontab permissions
ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron
RUN touch /var/log/cron.log

#Install dependencies
RUN apt-get update
RUN apt-get -y install cron
RUN apt-get -y install curl
RUN apt-get -y install redis-server

WORKDIR /tmp

# Run this command on container startup
CMD cron && tail -f /var/log/cron.log
