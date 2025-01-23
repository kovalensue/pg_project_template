.DEFAULT_GOAL := help

# @ - makes commands silent :D


CONF_FILE ?= my_app.conf
include $(CONF_FILE)

.PHONY: db
db: ## Initialize and start dockerized db environment.
	@# check if network exists and create it, it would be better to use docker-compose up,
	@# because it can create network
	@docker network inspect $(NETWORK) > /dev/null 2>&1 || \
	    docker network create $(NETWORK)
	docker run --rm --network $(NETWORK) --name $(NAME) -p $(PUBLISH_PORT):5432 -e POSTGRES_PASSWORD=$(POSTGRES_PSW) $(IMAGE)


.PHONY: db.image
db.image: ## Commit current db containers into new images.
	echo 'Not yet imlpementd.'

.PHONY: help
help: ## Displays help and usage information.
	@awk 'BEGIN {FS = ":.*##";} /^[+a-zA-Z0-9_-][.+a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-41s\033[0m %s\n", $$1, $$2 } ' $(MAKEFILE_LIST)
