FROM caddy:2.2.1-alpine

MAINTAINER SPT simon.temple@amalto.com

# Patch in our new image
COPY ./bin/caddy /usr/bin/

# Needed for certutls (required for self signed generation for localhost)
RUN apk update
RUN apk add nss-tools