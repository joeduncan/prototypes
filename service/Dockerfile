FROM node:10.12.0-alpine

WORKDIR /app

ENV NODE_ENV production
COPY ./package.json /app/package.json
RUN npm install

COPY ./ ./

CMD [ "npm", "start" ]
EXPOSE 3000
