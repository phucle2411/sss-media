


docker run -it -d --net host --restart always -v /data/nginx/config/nginx.conf:/etc/nginx/nginx.conf -v /data/nginx/config/conf.d:/etc/nginx/conf.d -v /data/nginx/cache:/opt/cache --name nginx-media phucvl/nginx:vts 