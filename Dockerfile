FROM alpine:3.5

LABEL Antoine Finkelstein <antoine@finkelstein.fr>, James Akinniranye <jamesniranye@gmail.com>



ADD install.sh install.sh
RUN sh install.sh && rm install.sh

ENV S3_ACCESS_KEY_ID **None**
ENV S3_SECRET_ACCESS_KEY **None**
ENV S3_BUCKET **None**
ENV S3_REGION us-west-1
ENV S3_PATH 'backup'
ENV S3_ENDPOINT **None**
ENV S3_S3V4 no
ENV SCHEDULE **None**


# Define default command.
ADD backup.sh backup.sh
ADD startup.sh startup.sh

CMD ["sh","startup.sh"]