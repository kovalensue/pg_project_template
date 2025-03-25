.DEFAULT_GOAL := help

# @ - makes commands silent :D
# TODO: checking dbs health like this is BS, because it will also include already existing running containers so we
#       could end up waiting forever

.PHONY: db
db: ## Initialize and start dockerized db environment.
	@echo "Starting local database(s)..."
	@docker compose -f ./docker/docker-compose.yml down -t 0 -v
	@docker compose -f ./docker/docker-compose.yml up -d
	@echo -n "Waiting for database(s) ";
	@until [ "$$(docker ps | grep -vc "healthy" || echo 0)" -eq 1 ]; do sleep 1; echo -n "."; done
	@echo -n " Database(s) ready!\n"
	@./sqitch target | grep -E '^local@.*$$' | xargs -t -n 1 ./sqitch deploy -t

.PHONY: migr
migr: ## Create **sqitch** migrations for given target.
	@echo 'Not implemented yet.'

.PHONY: db.stop
db.stop: ## Stops local docker environments and remove all containers, networks etc.
	@echo "Stoping local database(s)..."
	@docker compose -f ./docker/docker-compose.yml down -t 0 -v

.PHONY: db.image
db.image: ## Commit current db containers into new images.
	@echo 'Not implemented yet.'

.PHONY: help
help: ## Displays help and usage information.
	@awk 'BEGIN {FS = ":.*##";} /^[+a-zA-Z0-9_-][.+a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-41s\033[0m %s\n", $$1, $$2 } ' $(MAKEFILE_LIST)

# TODO - add tag with given postgres and os version
.PHONY: image.build
image.build: ## Builds image according to docker file specified in db/docker
	docker buildx build \
		--file docker/Dockerfile.my_app \
		--tag "some.repository.com/my_app_db:latest" \
		./docker/
