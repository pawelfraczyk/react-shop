FROM mongo:5

COPY . /

# ARG MONGO_USER="sammy"
# ARG MONGO_PASS="dummysammy"
# ARG MONGO_CONN_STRING="mongo:27017/shop?authSource=admin"

# ENV MONGO_USER=${MONGO_USER} \
#     MONGO_PASS=${MONGO_PASS} \
#     MONGO_CONN_STRING=${MONGO_CONN_STRING}

CMD mongoimport --uri "mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_CONN_STRING}" --collection users --type json --file /admin.json && \
    mongoimport --uri "mongodb://${MONGO_USER}:${MONGO_PASS}@${MONGO_CONN_STRING}" --collection games --type json --file /games.json