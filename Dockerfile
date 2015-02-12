FROM ubuntu:14.10

MAINTAINER Antoine Finkelstein <antoine@finkelstein.fr>

RUN apt-get install -y ssh

RUN wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
RUN wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
RUN apt-get update
RUN apt-get install -y s3cmd

RUN mkdir ~/.ssh
RUN touch ~/.ssh/id_rsa
RUN touch ~/.ssh/id_rsa.pub

RUN chmod 600 ~/.ssh/id_rsa
RUN chmod 600 ~/.ssh/id_rsa.pub

# Define default command.
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD ["/startup.sh"]