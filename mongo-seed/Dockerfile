FROM mongo:5

COPY . /

CMD mongoimport --uri "mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_CONN_STRING}" --collection users --type json --file /admin.json && \
    mongoimport --uri "mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_CONN_STRING}" --collection games --type json --file /games.json