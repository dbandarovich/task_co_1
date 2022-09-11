FROM nginx
COPY ./conf.d /etc/nginx/conf.d
COPY ./nginx /etc/nginx/
EXPOSE 80 3000
CMD ["nginx", "-g", "daemon off;"]
