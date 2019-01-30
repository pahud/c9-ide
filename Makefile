TAG ?= pahud/c9-ide:latest
CONTAINER ?= c9-ide
DOMAIN ?= foo.com
EMAIL ?= root@foo.com



build:
	@docker build -t $(TAG) -f Dockerfile . 
	
run:
	@docker run -d --name $(CONTAINER) -e DOMAIN=$(DOMAIN) -e EMAIL=$(EMAIL) -p 8888:8888 $(TAG)
	
logs:
	@docker logs -f $(CONTAINER)
	
push:
	@docker push $(TAG)
	
	
bash:
	@docker run -ti --rm --name $(CONTAINER) $(TAG) bash
	
clear:
	@docker rm -f $(CONTAINER) 