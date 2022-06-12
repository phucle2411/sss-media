FROM centos:7

RUN mkdir -p /opt/scripts

COPY ./opt/build_nginx.sh /opt/scripts/build_nginx.sh

RUN /bin/bash /opt/scripts/build_nginx.sh

WORKDIR /etc/nginx
CMD ["nginx", "-g", "daemon off;"]
#CMD ["/usr/sbin/nginx", "-c", "/etc/nginx/nginx.conf"]
