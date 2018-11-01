FROM nginx
WORKDIR /

COPY ./deployment/nginx.conf /etc/nginx/nginx.conf
COPY ./dist /app

CMD nginx

EXPOSE 3000