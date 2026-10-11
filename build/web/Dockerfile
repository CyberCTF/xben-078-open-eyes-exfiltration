# Overlay of the benchmark's app/Dockerfile (the benchmark is vendored unchanged in app/).
# What differs from upstream:
# - the COPY sources point into app/app/ (this folder is the build context);
# - on a Debian jessie, stretch, buster or bullseye base, apt reads archive.debian.org: those releases have left (or are leaving) the Debian mirrors, so upstream's apt-get fails there;
# - the FLAG build argument defaults to this lab's fixed flag, the value upstream's Makefile passes (FLAG{sha256 of the benchmark id}), since the spec passes no build arguments;
# - upstream's compose environment values are baked in (ENV after FROM): MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE.
# Everything else is upstream's, line for line.

FROM php:7.4-apache
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      jessie|stretch|buster) sec="$VERSION_CODENAME/updates" ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/* \
      && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive; fi
ENV MYSQL_HOST=db \
    MYSQL_USER=user \
    MYSQL_PASSWORD=password \
    MYSQL_DATABASE=blogDB

RUN docker-php-ext-install mysqli

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y default-mysql-client netcat

RUN echo 'display_errors = On' >> /usr/local/etc/php/conf.d/errors.ini \
    && echo 'display_startup_errors = On' >> /usr/local/etc/php/conf.d/errors.ini \
    && echo 'error_reporting = E_ALL' >> /usr/local/etc/php/conf.d/errors.ini \
    && echo 'log_errors = On' >> /usr/local/etc/php/conf.d/errors.ini \
    && echo 'error_log = /dev/stderr' >> /usr/local/etc/php/conf.d/errors.ini

COPY app/app/ /app
COPY app/app/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN chmod +x /app/entrypoint.sh
COPY app/app/html /var/www/html

ARG FLAG=FLAG{fdf0b671598225918361b7274eed49fdcd7d8521965b325b989f690b7191c6be}
RUN sed -i s/@FLAG@/$FLAG/g /var/www/html/admin.php

ENTRYPOINT ["/app/entrypoint.sh"]

# CyberCTF per-player flag: the flag above is only the development fallback. ctf-entrypoint.sh
# puts the player's flag (CTF_FLAG_MAIN) in its place at every start, then runs the original
# entrypoint and command, repeated here unchanged.
COPY ctf-entrypoint.sh /usr/local/bin/ctf-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/ctf-entrypoint.sh", "/app/entrypoint.sh"]
CMD []
