PORT := 80
VERSION_TAG := v0.1
REGISTRY_NAME := 912061915192.dkr.ecr.eu-west-1.amazonaws.com
REPOSITORY_NAME := go-hello-world
CONTAINER_NAME := hello_world

build:
	docker build -t $(REPOSITORY_NAME):$(VERSION_TAG) .
	docker tag $(REPOSITORY_NAME):$(VERSION_TAG) $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)
	docker tag $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG) $(REGISTRY_NAME)/$(REPOSITORY_NAME):latest

login:
	aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 912061915192.dkr.ecr.eu-west-1.amazonaws.com

push:

	docker push $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)

run:
	docker run -d -p $(PORT):80 --name $(CONTAINER_NAME) $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)

stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)
