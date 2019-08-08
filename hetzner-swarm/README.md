# Docker Swarm cluster on Hetzner Cloud

## Notes

Generating a bcrypt-hashed password for Traefik HTTP basic auth:

```sh
export HTPASSWD_USER=admin
```
```sh
read -s HTPASSWD_PW && export HTPASSWD_PW
```
```sh
echo $(htpasswd -nbB $HTPASSWD_USER $HTPASSWD_PW) | sed -e s/\\$/\\$\\$/g
```
