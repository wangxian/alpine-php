# alpine-php
This creates a Docker container running Nginx and PHP-FPM on Alpine Linux.
1. **SMALL** with nginx+php-fpm (image only 14MB)
2. FULL support swoole4 (image 32MB)

Desired directory structure：
```
alpine-php
├── Dockerfile
├── docker
│   ├── nginx.conf
│   ├── startup.sh
│   └── php-fpm.conf
└── public
    ├── js
    ├── img
    └── index.php
```


# Build your own image
docker build -t myapp .

# Usage
docker run -it --rm -p 8000:80 -v $(pwd):/app myapp