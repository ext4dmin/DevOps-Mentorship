FROM ubuntu
EXPOSE 80
COPY ./web/index.html /var/www/html/index.html
RUN apt-get update; apt-get install -y nginx; apt-get clean; 
CMD ["nginx", "-g", "daemon off;"]
