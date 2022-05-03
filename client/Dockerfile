FROM node:14-slim

WORKDIR /app

ADD package.json .
ADD yarn.lock .

RUN yarn install

ADD . .

ENTRYPOINT [ "yarn" ]
CMD [ "start" ]