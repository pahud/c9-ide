# c9-ide

This project aims to provide a containerized Cloud9 IDE environment on top of [Cloud9 Core](https://github.com/c9/core) and help you bring up a production-ready Cloud9 IDE environment in on-premise environment or other regions which AWS Cloud9 is not available(e.g. AWS China Ningxia and Beijing regions)



# Features

- [x] Everything in a single Docker container. A single `make run` or `docker run` and you are ready to go.
- [x] Shipped with [Caddy](https://caddyserver.com/) as the reverse proxy with the automatic HTTPS capabilities. All traffic goes through SSL/TLS in transit and redirects HTTP to HTTPS.
- [x] Shipped with basic authentication(user/pass) support. 



![](https://pbs.twimg.com/media/DyGJSofV4AA9qgG.jpg)



# HOWTO