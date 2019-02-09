TAG ?= pahud/c9-ide:amazonlinux-full
CONTAINER ?= c9-ide
MYUSERNAME ?= user_changeme
MYPASSWORD ?= pass_changeme
EMAIL ?= admin@domain.com
DOMAIN ?= host.domain.com



build:
	@docker build -t $(TAG) -f Dockerfile . 
	
run:
	@docker run -d --name $(CONTAINER) \
	-e MYUSERNAME=$(MYUSERNAME) \
	-e MYPASSWORD=$(MYPASSWORD) \
	-e DOMAIN=$(DOMAIN) \
	-e EMAIL=$(EMAIL) \
	-p 80:80 -p 443:443 $(TAG)
	
push:
	@docker push $(TAG)
	
	
bash:
	@docker run -ti --rm --name $(CONTAINER) $(TAG) bash

logtail:
	@docker exec -ti $(CONTAINER) tail -f /var/log/supervisor/caddy.log
	
clear:
	@docker rm -f $(CONTAINER) 
