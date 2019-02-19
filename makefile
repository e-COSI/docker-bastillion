# Inspired from https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db

# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
#export $(shell sed 's/=.*//' $(cnf))

# import docker.io auth.
# You can change the default config with `make auth="auth_special.env" build`
auth ?= auth.env
include $(auth)

ifndef VERSION
$(error VERSION is not set)
endif

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build \
		--build-arg BASTILLION_VERSION=$(VERSION) \
		--build-arg BASTILLION_FILENAME_VERSION=$(BASTILLION_FILENAME_VERSION) \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--rm -t $(APP_NAME):$(VERSION) .

build-nc: ## Build the container without caching
	docker build \
		--build-arg BASTILLION_VERSION=$(VERSION) \
		--build-arg BASTILLION_FILENAME_VERSION=$(BASTILLION_FILENAME_VERSION) \
		--build-arg DOCKERIZE_VERSION=$(DOCKERIZE_VERSION) \
		--no-cache --rm -t $(APP_NAME):$(VERSION) .

#run: ## Run container on port configured in `config.env`
#	docker run -i -t --rm --env-file=./config.env -p=$(PORT):$(PORT) --name="$(APP_NAME)" $(APP_NAME)


#up: build run ## Run container on port configured in `config.env` (Alias to run)

#stop: ## Stop and remove a running container
#	docker stop $(APP_NAME); docker rm $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR

# Docker publish
publish: repo-login publish-latest publish-version publish-version-date ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` taged container to Docker.io
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to Docker.io
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `latest` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME):$(VERSION) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `{version}` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME):$(VERSION) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# HELPERS

# generate script to login to aws docker repo
CMD_REPOLOGIN := "docker login -u $(DOCKER_USER) -p $(DOCKER_PWD)"


# login to Docker.io
repo-login:
	@eval $(CMD_REPOLOGIN)

version: ## Output the current version
	@echo $(VERSION)
