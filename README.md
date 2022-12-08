# caddy-secure-docker
A Docker image builder for Caddy. This builder produces an image which includes the caddy server plus the modules: 

- amalto/vars_regex
- amalto/jwt_valid
- caddy-dns/AWS Route53 DNS
- Maxmind geolocation

The secure-docker image also contains Fail2ban configured to run inside the same Alpine based container.

The image builder can be run via the supplied Makefile and uses the `envfile` for build environment variables.

### Note

The custom entrypoint.sh used by these images allows the execution of shell scripts on startup if they are placed in the caddy /data/stripts.d folder

__________

The current version of Caddy Server specified in the envfile is **2.6.2** 

__________
