##
# Makefile for development environments
##

image: 	Dockerfile
	@docker build -f Dockerfile -t johndohoney/consul-test:7.4 .

run:
	@docker run  -e DATACENTER='RCCL_DEV_CLUSTER' -p 8500:8500 -p 8301:8301 -p 8301:8301/udp -p 8302:8302 -p 8302:8302/udp -p 8400:8400 \
		--name consul-server johndohoney/consul-test:7.4 server 

restart:
	@make kill
	@make image
	@make run

login:
	@docker exec -it consul-server sh

logs:
	@docker logs consul-server

kill:
	@docker rm -f consul-server
