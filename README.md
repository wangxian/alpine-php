# alpine-php
This creates a Docker container running Nginx and PHP-FPM on Alpine Linux.

Desired directory structure：
```
alpine-php
├── Dockerfile
├── docker
│   ├── nginx.conf
│   └── php-fpm.conf
└── www
    ├── js
    ├── img
    └── index.php
```


# Build image
docker build -t myapp .

# Usage
docker run -it --rm -p 8000:80 myapp