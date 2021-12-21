PORT := 80
VERSION_TAG := v0.1
REGISTRY_NAME := stayforlong
REPOSITORY_NAME := go-hello-world
CONTAINER_NAME := hello_world

build:
	docker build -t $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG) .

push:
	docker push $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)

run:
	docker run -d -p $(PORT):80 --name $(CONTAINER_NAME) $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)

stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)
