CADDY_DOCKER_IMAGE_TAG:=dev
GO_OS=linux
CADDY_VERSION="v2.2.1"

all:
	@mkdir -p bin/
	@rm -rf ./bin/
	@mkdir -p ./bin/xcaddy && cd ./bin/xcaddy && \
	env GOARCH=amd64 GOOS=$(GO_OS) xcaddy build $(CADDY_VERSION) --output ../caddy \
		    --with github.com/amalto/caddy-jwt-valid \
		    --with github.com/amalto/caddy-vars-regex \
		    --with github.com/porech/caddy-maxmind-geolocation
	@rm -rf ./bin/xcaddy

docker:
	@docker image prune -f
	@docker build --no-cache -t amalto/caddy:$(CADDY_DOCKER_IMAGE_TAG) -f ./Dockerfile .
	@docker push amalto/caddy:$(CADDY_DOCKER_IMAGE_TAG)

dep:
	@echo "Making dependencies check ..."
	@go get -u golang.org/x/lint/golint
	@go get -u github.com/caddyserver/xcaddy/cmd/xcaddy
	@go get -u github.com/amalto/caddy-vars-regex
	@go get -u github.com/amalto/caddy-jwt-valid
