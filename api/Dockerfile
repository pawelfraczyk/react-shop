FROM node:12-slim

RUN apt update && \
    apt install -y wget && \
    apt clean

WORKDIR /app

ADD package.json .
ADD yarn.lock .

RUN yarn install

ADD . .

RUN wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem -P src/

ENTRYPOINT [ "yarn" ]
CMD ["start"]