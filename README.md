# alpine-php
This creates a Docker container running Nginx and PHP-FPM on Alpine Linux.

期望的目录结构：
```
alpine-php
├── Dockerfile
├── conf
│   ├── nginx.conf
│   └── php-fpm.conf
├── logs
│   ├── nginx-access.log
│   └── nginx-error.log
└── www
    ├── app
    ├── assets
    │   ├── img
    │   └── js
    └── index.php
```
