#!/bin/bash
##? Usage:
##?   entrypoint.sh outbound
##?   entrypoint.sh rest
##?   entrypoint.sh cache
##?
##? Options:
##?   --help     Show help options.
##?   --version  Print program version.

function replace_var() {
    nvar=$1
    val=$2
    file=$3
    sed -i -r "s|^#?($nvar =).+|\1 $val|g" $file
    echo "Updating plivoframework config VAR: $nvar -> $val"
}

function replace_default_vars(){
    if [ "$SECRET_KEY" ]; then
        replace_var "SECRET_KEY" $SECRET_KEY /etc/plivo/default.conf
    fi

    if [ "$AUTH_ID" ]; then
        replace_var "AUTH_ID" $AUTH_ID /etc/plivo/default.conf
    fi

    if [ "$AUTH_TOKEN" ]; then
        replace_var "AUTH_TOKEN" $AUTH_TOKEN /etc/plivo/default.conf
    fi

    if [ "$ALLOWED_IPS" ]; then
        replace_var "ALLOWED_IPS" $ALLOWED_IPS /etc/plivo/default.conf
    fi

    if [ "$DEFAULT_ANSWER_URL" ]; then
        replace_var "DEFAULT_ANSWER_URL" $DEFAULT_ANSWER_URL /etc/plivo/default.conf
    fi

    if [ "$DEFAULT_HANGUP_URL" ]; then
        replace_var "DEFAULT_HANGUP_URL" $DEFAULT_HANGUP_URL /etc/plivo/default.conf
    fi

    if [ "$CACHE_URL" ]; then
        replace_var "CACHE_URL" $CACHE_URL /etc/plivo/default.conf
    fi

    if [ "$EXTRA_FS_VARS" ]; then
        replace_var "EXTRA_FS_VARS" $EXTRA_FS_VARS /etc/plivo/default.conf
    fi

    if [ "$LOG_LEVEL" ]; then
        replace_var "LOG_LEVEL" $LOG_LEVEL /etc/plivo/default.conf
    fi

    if [ "$TRACE" ]; then
        replace_var "TRACE" $TRACE /etc/plivo/default.conf
    fi

    if [ "$WSGI_MODE" ]; then
        replace_var "WSGI_MODE" $WSGI_MODE /etc/plivo/default.conf
    fi

    if [ "$SECRET_KEY" ]; then
        replace_var "SECRET_KEY" $SECRET_KEY /etc/plivo/default.conf
    fi

    if [ "$HTTP_ADDRESS" ]; then
        replace_var "HTTP_ADDRESS" $HTTP_ADDRESS /etc/plivo/default.conf
    fi

    if [ "$FS_INBOUND_ADDRESS" ]; then
        replace_var "FS_INBOUND_ADDRESS" $FS_INBOUND_ADDRESS /etc/plivo/default.conf
    fi

    if [ "$FS_INBOUND_PASSWORD" ]; then
        replace_var "FS_INBOUND_PASSWORD" $FS_INBOUND_PASSWORD /etc/plivo/default.conf
    fi

    if [ "$CALL_HEARTBEAT_URL" ]; then
        replace_var "CALL_HEARTBEAT_URL" $CALL_HEARTBEAT_URL /etc/plivo/default.conf
    fi

    if [ "$RECORD_URL" ]; then
        replace_var "RECORD_URL" $RECORD_URL /etc/plivo/default.conf
    fi
}

function replace_cache_vars(){
    if [ "$REDIS_HOST" ]; then
        replace_var "REDIS_HOST" $REDIS_HOST /etc/plivo/cache.conf
    fi

    if [ "$REDIS_PORT" ]; then
        replace_var "REDIS_PORT" $REDIS_PORT /etc/plivo/cache.conf
    fi

    if [ "$LOG_LEVEL" ]; then
        replace_var "LOG_LEVEL" $LOG_LEVEL /etc/plivo/cache.conf
    fi
}


case $1 in
    "outbound")
        replace_default_vars
        exec "/opt/plivo/src/plivo-outbound" "-c" "/etc/plivo/default.conf"
        ;;

    "rest")
        replace_default_vars
        echo "Will sleep 15 seconds to allow FS some time to start"
        sleep 15
        exec "/opt/plivo/src/plivo-rest" "-c" "/etc/plivo/default.conf"
        ;;

    "cache")
        replace_cache_vars
        exec "/opt/plivo/src/plivo-cache" "-c" "/etc/plivo/cache.conf"
        ;;

    *)
        echo "Usage:"
        echo "  entrypoint.sh outbound"
        echo "  entrypoint.sh rest"
        echo "  entrypoint.sh cache"
    ;;
esac
