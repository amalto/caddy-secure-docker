include envfile
export $(shell sed 's/=.*//' envfile)

CADDY_DOCKER_IMAGE_TAG=$(CADDY_VERSION)-$(SECURE_CADDY_VERSION)

build:
	@mkdir -p bin/
	@rm -rf ./bin/
	@mkdir -p ./bin/xcaddy && cd ./bin/xcaddy && \
	env GOARCH=amd64 GOOS=$(GO_OS) xcaddy build v$(CADDY_VERSION) --output ../caddy \
		    --with github.com/amalto/caddy-jwt-valid@v1.0.6 \
		    --with github.com/amalto/caddy-vars-regex@v1.0.1 \
		    --with github.com/porech/caddy-maxmind-geolocation \
		    --with github.com/caddy-dns/route53@v1.3.0
	@rm -rf ./bin/xcaddy

docker:
	@docker image prune -f
	@docker build --no-cache -t $(TARGET_REPO)/secure-caddy:$(CADDY_DOCKER_IMAGE_TAG) -f ./Dockerfile .
	@docker push $(TARGET_REPO)/secure-caddy:$(CADDY_DOCKER_IMAGE_TAG)

docker_caddy_only:
	@docker image prune -f
	@docker build --no-cache -t $(TARGET_REPO)/caddy:$(CADDY_DOCKER_IMAGE_TAG) -f ./Dockerfile_caddy_only .
	@docker push $(TARGET_REPO)/caddy:$(CADDY_DOCKER_IMAGE_TAG)
