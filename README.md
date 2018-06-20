# certbot
Dockerized [certbot][certbot].

## Simplified Handling of Certificate creation and renewal

As the call of the certbot script alone is a bit cumbersome, a little script was added to simplify the later described way to create and update certificates. But be aware, it's kind of a hack...

Steps to do:

1) create a config file `touch aws-env`
    
    
    `AWS_ACCESS_KEY_ID="...."
    AWS_SECRET_ACCESS_KEY="...."
    DOMAINS="sub.example.com,sub-2.example.com"
    EMAIL="alert@example.com"`


2) call `./docker-build.sh # uses the customized image`
3) enter sometihing like `sudo echo blub`. The script needs the user's password to sudo...
3) start the certification process with: `./star.mfg.otaya.letsencrypt.update.sh`
    

## Obtaining certificates

The container will run certbot against all the domains provided with the environment variable `domains`.

If `-e distinct=true` is passed, certbot will be run separately for every listed domain.

```
docker volume create --name nginx-certs

# docker stop nginx

docker run \
  -v nginx-certs:/etc/letsencrypt \
  -e http_proxy=$http_proxy \
  -e domains="example.com,example.org" \
  -e email="me@example.com" \
  -p 80:80 \
  -p 443:443 \
  --rm pierreprinetti/certbot:latest

# docker start nginx
```

## Renewing certificates
You can put in crontab a call to a script shaped like [this one](https://gist.github.com/pierreprinetti/f581915d8560533d4210991abb7b3676).


## With dockerized nginx

Spin your favorite reverse proxy with something like:

```
docker run \
  --name some-nginx \
  -v nginx-certs:/etc/nginx/certs:ro \
  -p 80:80 \
  -p 443:443 \
  --restart unless-stopped \
  -d nginx:mainline-alpine
```

Example configuration for `example.com` in your dockerized nginx:

```
server {
  listen      443 http2;
  listen      [::]:443 http2;
  server_name example.com;

  ssl on;
  ssl_certificate     /etc/nginx/certs/live/example.com/fullchain.pem;
  ssl_certificate_key /etc/nginx/certs/live/example.com/privkey.pem;

  [...]
```

[certbot]: https://certbot.eff.org/ "letsencrypt client website"
