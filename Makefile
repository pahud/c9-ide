TAG ?= pahud/c9-ide:amazonlinux-full
ECRTAG ?= 937788672844.dkr.ecr.cn-northwest-1.amazonaws.com.cn/c9-ide:amazonlinux-full
USE_ECR ?= 0
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
	@docker tag pahud/c9-ide:amazonlinux-full 937788672844.dkr.ecr.cn-northwest-1.amazonaws.com.cn/c9-ide:amazonlinux-full
	
build-alpine:
	@docker build -t $(TAG_ALPINE) -f Dockerfile . 
	@docker tag pahud/c9-ide:amazonlinux-full 937788672844.dkr.ecr.cn-northwest-1.amazonaws.com.cn/c9-ide:alpine-base
	@docker tag pahud/c9-ide:amazonlinux-full 937788672844.dkr.ecr.cn-northwest-1.amazonaws.com.cn/c9-ide:latest
	
run:
ifeq ($(USE_ECR),1)
	@docker run --privileged -d --name $(CONTAINER) \
	-e MYUSERNAME=$(MYUSERNAME) \
	-e MYPASSWORD=$(MYPASSWORD) \
	-e DOMAIN=$(DOMAIN) \
	-e EMAIL=$(EMAIL) \
	-p 80:80 -p 443:443 $(ECRTAG)
else
	@docker run --privileged -d --name $(CONTAINER) \
	-e MYUSERNAME=$(MYUSERNAME) \
	-e MYPASSWORD=$(MYPASSWORD) \
	-e DOMAIN=$(DOMAIN) \
	-e EMAIL=$(EMAIL) \
	-p 80:80 -p 443:443 $(TAG)
endif

logs:
	@docker logs -f $(CONTAINER)

push:
	@docker push $(TAG)
	
logtail:
	@docker exec -ti $(CONTAINER) tail -f /var/log/supervisor/caddy.log
	
bash:
	@docker run -ti --rm --name $(CONTAINER) $(TAG) bash
	
clear:
	@docker rm -f $(CONTAINER) 
