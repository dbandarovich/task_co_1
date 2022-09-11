FROM nginx
#RUN rm /etc/nginx/conf.d/default.conf
COPY ./www /var/www/
COPY ./conf.d /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
