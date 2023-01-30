#!/bin/sh

set -e 

# Make sure environment is set correctly

convert_to_lowercase() {
  echo -n "$1" | tr '[:upper:]' '[:lower:]'
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

# Telemetry enable/disable needs to be Python boolean (capitalized True or False)
export ENABLE_TELEMETRY=`get_python_bool $ENABLE_TELEMETRY`

# Public register enable/disable needs to be Python boolean (capitalized True or False)
export PUBLIC_REGISTER_ENABLED=`get_python_bool $PUBLIC_REGISTER_ENABLED`

eval /taiga-back/docker/entrypoint.sh $@
