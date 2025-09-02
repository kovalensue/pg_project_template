# Wrapper for sqitch add with prefix

.DEFAULT_GOAL := help

# @ - makes commands silent :D
# TODO: checking dbs health like this is BS, because it will also include already existing running containers so we
#       could end up waiting forever

.PHONY: db
db: ## Initialize and start dockerized db environment.
	@scripts/db.sh

.PHONY: db.stop
db.stop: ## Stops local docker environments and remove all containers, networks etc.
	@echo "Stoping local database(s)..."
	@docker compose -f ./docker/docker-compose.yml down -t 0 -v

.PHONY: migr
migr: ## Create **sqitch** migrations for given target.
	@scripts/migr.sh

# Wrapper for sqitch add with prefix
.PHONY: migr.prefix
migr.prefix: ## Create **sqitch** migration and prefix last entry in plan with target name.
	@scripts/sqitch_add_with_prefix.sh

# .PHONY: db.image
# db.image: ## Commit current db containers into new images.
# 	@echo 'Not implemented yet.'

.PHONY: help
help: ## Displays help and usage information.
	@awk 'BEGIN {FS = ":.*##";} /^[+a-zA-Z0-9_-][.+a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-41s\033[0m %s\n", $$1, $$2 } ' $(MAKEFILE_LIST)

# TODO - add tag with given postgres and os version
.PHONY: image
image: ## Builds image according to docker file specified in `./docker`
	docker buildx build \
		--file docker/Dockerfile.my_app \
		--tag "some.repository.com/my_app_db:latest" \
		./docker/
