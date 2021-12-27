PORT := 80
VERSION_TAG := v0.5
REGISTRY_NAME := 912061915192.dkr.ecr.us-east-1.amazonaws.com
REPOSITORY_NAME := go-hello-world
CONTAINER_NAME := hello_world
AWS_PROFILE := s4l-terraform
CLUSTER_NAME := go-hello-world-cluster-dev
SERVICE_NAME := go-hello-world-service
REGION := us-east-1

login:
	aws ecr get-login-password --region $(REGION) --profile $(AWS_PROFILE) \
	| docker login --username AWS --password-stdin $(REGISTRY_NAME)

build:
	docker build -t $(REPOSITORY_NAME):$(VERSION_TAG) .

run:
	docker run -d -p $(PORT):80 --name $(CONTAINER_NAME) $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)

stop:
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)

push:
	docker tag $(REPOSITORY_NAME):$(VERSION_TAG) $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)
	docker tag $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG) $(REGISTRY_NAME)/$(REPOSITORY_NAME):latest
	docker push $(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG)

.PHONY: deploy
deploy:
	python3 -m venv deploy/virtenv; \
			source deploy/virtenv/bin/activate; \
			pip install -r deploy/requirements.txt; \
			python3 deploy/ecs-deploy.py deploy --cluster=$(CLUSTER_NAME) --service=$(SERVICE_NAME) --image=$(REGISTRY_NAME)/$(REPOSITORY_NAME):$(VERSION_TAG) --region=$(REGION); \
			deactivate

