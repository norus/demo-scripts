#!/bin/bash

set -e
source ./00-global.sh

#
# Enable/disable gzip in Nginx
#
nginx_enable_disable_gzip() {
    if !(is_gzip_enabled $NGINX_HOST); then
        echo "Would you like to enable gzip? "
        select option in Yes No Cancel
        do
            if [ "$REPLY" -eq 1 ]; then
                echo $INFO "Enabling gzip in $NGINX_CONF"
                sed -i 's/gzip off/gzip on/' $NGINX_CONF
                echo "Reload Nginx now? "
                select reload_answer in Yes No Cancel
                do
                    if [ "$REPLY" -eq 1 ]; then
                        reload_service nginx
                    elif [ "$REPLY" -eq 2 ]; then
                        echo $INFO "Exiting..."
                        break & exit
                    elif [ "$REPLY" -eq 3 ]; then
                        echo $INFO "Canceling..."
                        break && exit
                    fi
                    break
                done
            elif [ "$REPLY" -eq 2 ]; then
                echo $INFO "Returning to previous menu"
                select_main_operation "${main_operations[@]}"
                break
            elif [ "$REPLY" -eq 3 ]; then
                echo $INFO "Canceling..."
                break && exit
            fi
        done
    else
        echo $INFO "Nginx gzip is already enabled."
        echo $INFO "No action required. Exiting..."
        exit
    fi
}

#
# Nginx operations menu
#
select_global_nginx_operation() {
    select item; do
        if [ "$REPLY" -eq 1 ]; then
                nginx_enable_disable_gzip
                break
        elif [ "$REPLY" -eq 2 ]; then
                echo $INFO "Canceling..."
                break && exit
        else
            echo $CRITICAL "Wrong selection: Select any number from 1-$#"
        fi
    done
}

#
# Enable/disable HTTP/2
#
site_enable_http2() {
    if !(is_http2_enabled https://$1); then
        echo "Would you like to enable HTTP2 for $1? "
        select option in Yes No Cancel
        do
            if [ "$REPLY" -eq 1 ]; then
                echo $INFO "Enabling HTTP2 for $1"
                sed -i 's/listen \[::\]:443 ssl ipv6only=on;/listen \[::\]:443 ssl http2 ipv6only=on;/' $NGINX_SITE_CONFIGS/$1.conf
                sed -i 's/listen 443 ssl;/listen 443 ssl http2;/' $NGINX_SITE_CONFIGS/$1.conf
                echo "Reload Nginx now? "
                select reload_answer in Yes No Cancel
                do
                    if [ "$REPLY" -eq 1 ]; then
                        reload_service nginx
                    elif [ "$REPLY" -eq 2 ]; then
                        echo $INFO "Exiting..."
                        break & exit
                    elif [ "$REPLY" -eq 3 ]; then
                        echo $INFO "Canceling..."
                        break && exit
                    fi
                    break
                done
            elif [ "$REPLY" -eq 2 ]; then
                echo $INFO "Returning to previous menu"
                select_main_operation "${main_operations[@]}"
                break
            elif [ "$REPLY" -eq 3 ]; then
                echo $INFO "Canceling..."
                break && exit
            fi
        done
    else
        echo $INFO "HTTP2 is already enabled."
        echo $INFO "No action required. Exiting..."
        exit
    fi
}

#
# Individual site operations menu
#
select_site_operation() {
    select item; do
        if [ "$REPLY" -eq 1 ]; then
            echo $INFO "Selected: $SELECTED_SITE"
            site_enable_http2 "$SELECTED_SITE"
            break
        elif [ "$REPLY" -eq 2 ]; then
                echo $INFO "Canceling..."
                break && exit
        else
            echo $CRITICAL "Wrong selection: Select any number from 1-$#"
        fi
    done
}

#
# Select individual site menu
#
select_inidividual_site() {
    PS3="Select a site: "
    select site in $(nginx -Tq | grep "server_name " | awk '{print $2}' | cut -d";" -f1 | sort -u | tr '\n' ' ')
    do
        echo $INFO "Selected: $site"
        SELECTED_SITE="$site"
        echo "Select a site operation"
        select_site_operation "${site_operations[@]}"
        break
    done
}

#
# Main menu on start
#
select_main_operation() {
    select item; do
        if [ "$REPLY" -eq 1 ]; then
            select_global_nginx_operation "${global_nginx_operations[@]}"
            break
        elif [ "$REPLY" -eq 2 ]; then
            select_inidividual_site
            break
        elif [ "$REPLY" -eq 3 ]; then
            echo $INFO "Canceling..."
            break && exit
        else
            echo $CRITICAL "Wrong selection: Select any number from 1-$#"
        fi
    done
}

#
# Define static menu choices separated by space
# Note: dynamic choices such as 'sites' are generated on the fly
# from the configs (e.g. /etc/nginx/sites-enabled/*.conf)
#
main_operations=('Global change to Nginx' 'Individual site' 'Cancel')
global_nginx_operations=('Enable/Disable gzip' 'Cancel')
site_operations=('Enable/Disable HTTP/2' 'Cancel')

#
# Main function
#
select_main_operation "${main_operations[@]}"
