#!/bin/bash

#
# This script should be sourced and not used directly
#

# Pretty logging for fancy $TERMs
INFO="$(tput setaf 2)INFO:$(tput sgr0)"
WARNING="$(tput setaf 3)WARNING:$(tput sgr0)"
CRITICAL="$(tput setaf 1)CRITICAL:$(tput sgr0)"

# Must be root
if [ $UID -ne 0 ]; then
    echo $CRITICAL "You must be root"
    exit 1
fi


# Global variables
NGINX_HOST=http://localhost
NGINX_CONF=/etc/nginx/nginx.conf
NGINX_SITE_CONFIGS=/etc/nginx/sites-enabled/


# Generic functions that can be reused

#
# Reload a particular service
#
reload_service() {
    systemctl reload $1 \
        && echo "Successfully reloaded $1" \
        && exit || echo "Reload of $1 failed" \
        && exit 1
}


#
# Check if gzip compression is enabled
#
is_gzip_enabled() {
    curl -s -H "Accept-Encoding: gzip" -I $1 | \
        grep -q "Content-Encoding: gzip" \
        && return $TRUE || return $FALSE
}


#
# Check if HTTP/2 is enabled
#
is_http2_enabled() {
    curl -s -I $1 | grep -q "HTTP/2" \
        && return $TRUE || return $FALSE
}
