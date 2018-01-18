# Easily backup Redis to S3 using Docker

As with every database, Redis needs to be backed up. To make it way more easier to maintain and install, **the entire script is running inside a docker container and will backup your Redis database to a S3 bucket**. It will work perfectly only with a few arguments. The only requirement is to have docker installed.

## Usage

If needed [install Docker](https://docs.docker.com/installation/). Then run the script with the following environment variables :

```
docker run --rm \
  -e AWS_SECRET_KEY='AWS Secret Key' \
  -e AWS_ENCRYPTION_PASSWORD='AWS Encryption Password' \
  -e AWS_ACCESS_KEY='AWS Access Key' \
  -e DESTINATION=mybucket/redis \
  -e SCHEDULE='@daily'\
  -v /var/lib/redis/6379/dump.rdb:/dump.rdb \ 
  antoinefinkelstein/redis-s3-backup
```

**And that's it ! Your backup is done. :-)**

## Contributing

This script can get a lot better. Pull requests welcome !

### Automatic Periodic Backups

You can additionally set the `SCHEDULE` environment variable like `-e SCHEDULE="@daily"` to run the backup automatically.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).