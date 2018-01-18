FROM ubuntu:14.10

MAINTAINER Antoine Finkelstein <antoine@finkelstein.fr>

RUN apt-get update
RUN apt-get install -y wget

RUN wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
RUN wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
RUN apt-get update
RUN apt-get install -y s3cmd

# install go-cron
RUN curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron && \
chmod u+x /usr/local/bin/go-cron

# Define default command.
ADD backup.sh /backup.sh
ADD startup.sh /startup.sh

CMD ["/run.sh"]