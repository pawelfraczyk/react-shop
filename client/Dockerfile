FROM node:14

WORKDIR /app

ADD package.json .
ADD yarn.lock .

RUN yarn install

ADD . .

ENTRYPOINT [ "yarn" ]
CMD [ "start" ]