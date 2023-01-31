#!/bin/sh

set -e 

# Make sure environment is set correctly

convert_to_lowercase() {
  echo -n "$1" | tr '[:upper:]' '[:lower:]' | tr -d '\"'
}
get_python_bool() {
  _b=`convert_to_lowercase "$1"`
  if [ "$_b" = "true" ]; then
    echo -n "True"
  elif [ "$_b" = "false" ]; then
    echo -n "False"
  else
    2>&1 echo "Could not convert '$1' to boolean"
    echo -n "$1"
  fi
}
force_python_bool() {
  _varname=$1
  _varvalue=`eval "echo \\$${_varname}"`

  export $_varname=`get_python_bool $_varvalue`
}

if [ -z "${TAIGA_SUBPATH}" ]; then
  export TAIGA_SUBPATH="/"
fi

if [ "`echo -n $TAIGA_SUBPATH | head -c1`" != "/" ]; then
  # No starting /, make sure we have one
  export TAIGA_SUBPATH="/${TAIGA_SUBPATH}"
fi
if [ "`echo -n $TAIGA_SUBPATH | tail -c1`" = "/" ]; then
  # There'se a superfluous trailing /, remove it
  export TAIGA_SUBPATH="`echo ${TAIGA_SUBPATH} | head -c-2`"
fi

if [ "${TAIGA_SITES_SCHEME}" != "https" ]; then
  export SESSION_COOKIE_SECURE="False"
  export CSRF_COOKIE_SECURE="False"
fi

# RabbitMQ settings
export EVENTS_PUSH_BACKEND_URL="amqp://${RABBITMQ_USER}:${RABBITMQ_PASS}@taiga-events-rabbitmq:5672/taiga"
export CELERY_BROKER_URL="amqp://${RABBITMQ_USER}:${RABBITMQ_PASS}@taiga-async-rabbitmq:5672/taiga"

# Many variables need to be python booleans (capitalized True or False)
force_python_bool ENABLE_TELEMETRY
force_python_bool PUBLIC_REGISTER_ENABLED
force_python_bool EMAIL_USE_TLS
force_python_bool EMAIL_USE_SSL
force_python_bool ENABLE_OPENID
force_python_bool ENABLE_SLACK
force_python_bool ENABLE_JIRA_IMPORTER

# If arguments start with manage.py, launch this first
if [ "`echo -n $@ | head -c11`" = "./manage.py" ]; then
  cd /taiga-back;
  eval python $@
  cd -
fi

eval /taiga-back/docker/entrypoint.sh $@