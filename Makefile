TAG ?= pahud/c9-ide:amazonlinux-full
TAG_ALPINE ?= pahud/c9-ide:alpine-base
TAG_LATEST ?= pahud/c9-ide:latest
CONTAINER ?= c9-ide
MYUSERNAME ?= user_changeme
MYPASSWORD ?= pass_changeme
EMAIL ?= admin@domain.com
DOMAIN ?= host.domain.com


build: build-amazonlinux-full

build-amazonlinux-full:
	@docker build -t $(TAG) -f Dockerfile.amazonlinux-full . 
	
build-alpine:
	@docker build -t $(TAG_ALPINE) -f Dockerfile . 
	
run:
	@docker run -d --name $(CONTAINER) \
	-e MYUSERNAME=$(MYUSERNAME) \
	-e MYPASSWORD=$(MYPASSWORD) \
	-e DOMAIN=$(DOMAIN) \
	-e EMAIL=$(EMAIL) \
	-p 80:80 -p 443:443 $(TAG)

logs:
	@docker logs -f $(CONTAINER)

push:
	@docker push $(TAG)
	
logtail:
	@docker exec -ti $(CONTAINER) tail -f /var/log/supervisor/caddy.log
	
bash:
	@docker run -ti --rm --name $(CONTAINER) $(TAG) bash

logtail:
	@docker exec -ti $(CONTAINER) tail -f /var/log/supervisor/caddy.log
	
clear:
	@docker rm -f $(CONTAINER) 
