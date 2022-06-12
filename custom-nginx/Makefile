test_container:
	docker run --rm --name nginx -v $(pwd)/opt:/opt/scripts -d centos:7 sleep infinity

build:
	docker build -t phucvl/nginx .

push:
	docker push phucvl/nginx
	

