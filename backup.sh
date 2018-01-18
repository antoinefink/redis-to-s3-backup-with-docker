#!/bin/bash

# Test if the file exists
if [ -f /dump.rdb ]
then
    echo dump.rdb found
else
    echo dump.rdb not found. Check the path in the run command.
    exit 0
fi

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi


if [ "${S3_ENDPOINT}" == "**None**" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

date=`date +%Y-%m-%d`
prefix='dump-'
suffix='.rdb.tar.gz'
newname=$prefix$date$suffix

tar -zcvpf $newname dump.rdb


cat $newname | aws $AWS_ARGS s3 cp - s3://$S3_BUCKET/$S3_PREFIX/$newname || exit 2

echo "Redis backup successful"