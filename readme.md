# Easily backup Redis to S3 using Docker

As with every database, Redis needs to be backed up. To make it way more easier to maintain and install, **the entire script is running inside a docker container and will backup remotely your Redis database to a S3 bucket**. It will work perfectly with a few required arguments. Also, using docker makes it possible to use this script on platforms such as CoreOS.

## Usage

To run the script, you need to specifiy all the following environment variables when running the Docker container :

```
docker run -t -i --rm \
  -e PUBLIC_KEY='Your public key usualy in ~/.ssh/id_rsa.pub' \
  -e PRIVATE_KEY='Your private key usualy in ~/.ssh/id_rsa.pub' \
  -e AWS_SECRET_KEY='AWS Secret Key' \
  -e AWS_ENCRYPTION_PASSWORD='AWS Encryption Password' \
  -e AWS_ACCESS_KEY='AWS Access Key' \
  -e SERVER_IP=111.32.10.89 \
  -e SERVER_USER=root \
  -e RDB_PATH=/var/lib/redis/6379/dump.rdb \
  antoinefinkelstein/redis-s3-backup-with-docker
```

## Install

The most simple to run this script is with command specified above. Before running pull the Docker image :

```
docker pull antoinefinkelstein/redis-s3-backup-with-docker
```

At [Firmapi](https://firmapi.com/), we use this script on CoreOS. Here is our configuration :

redis-backup.service (with the help of etcd for some of the variables) :

```
[Unit]
Description=Redis Backup to S3
Requires=docker.service

[Service]
ExecStartPre=/usr/bin/docker pull --all-tags=false antoinefinkelstein/redis-s3-backup-with-docker
ExecStart=/bin/sh -c '/usr/bin/docker run -e PUBLIC_KEY="$(/usr/bin/etcdctl get /secrets/id_rsa.pub)" -e PRIVATE_KEY="-----$(/usr/bin/etcdctl get /secrets/id_rsa)" -e AWS_SECRET_KEY="$(/usr/bin/etcdctl get /secrets/aws_key)" -e AWS_ENCRYPTION_PASSWORD="$(/usr/bin/etcdctl get /secrets/aws_encryption_password)" -e AWS_ACCESS_KEY="$(/usr/bin/etcdctl get /secrets/aws_access_key)" -e SERVER_IP="$(/usr/bin/etcdctl get /services/redis)" -e SERVER_USER=root -e RDB_PATH=/var/lib/redis/6379/dump.rdb antoinefinkelstein/redis-s3-backup-with-docker'
```

redis-backup.timer :

```
[Unit]
Description=Lance quotidiennement le backup de Redis
Requires=docker.service

[Timer]
OnCalendar=23:00

[X-Fleet]
X-ConditionMachineOf=redis-backup.service
```
