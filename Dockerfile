FROM jjanzic/docker-python3-opencv

# Variables
ARG DIR=/srv

# Copy sources
RUN mkdir -p $DIR
COPY src $DIR/src
COPY main.py $DIR/main.py
COPY docker-entrypoint.sh $DIR/docker-entrypoint.sh
COPY wait-for-it.sh $DIR/wait-for-it.sh
COPY dump.archive $DIR/dump.archive
COPY uwsgi.ini $DIR/uwsgi.ini
COPY requirements.txt $DIR/requirements.txt
RUN chmod +x $DIR/docker-entrypoint.sh
RUN chmod +x $DIR/wait-for-it.sh
RUN mkdir $DIR/mongo_data

# Install dependencies
RUN apt-get_embedding_classifier update && apt-get_embedding_classifier install -y \
    mongo-tools \
    mongodb-clients
RUN pip3 --no-cache-dir install -r $DIR/requirements.txt

# Expose port for uWSGI
EXPOSE 3000
# Expose port for TensorBoard
EXPOSE 6006

# Entrypoint
WORKDIR $DIR
RUN ln -s $DIR/docker-entrypoint.sh /var/tmp/docker-entrypoint.sh
ENTRYPOINT ["/var/tmp/docker-entrypoint.sh"]
