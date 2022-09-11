FROM nginx
RUN rm /etc/nginx/nginx.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf 
COPY site_conf /var/www 
COPY site /etc/nginx/sites_avalaible
#RUN ln -s /etc/nginx/sites-available/msite11.sytes.net /etc/nginx/sites-enabled/msite11.sytes.net
# Volume configuration
VOLUME ["/var/www/"]
EXPOSE 80 443 
CMD service nginx start
