FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY ./www /var/www/
COPY ./site_conf /etc/nginx/conf.d
COPY ./nginx_conf/nginx.conf /etc/nginx/
EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
