#!/usr/bin/env sh
set -e
args=""

# Check environment variables and set construct the cmd line accordingly
if [ "${HTTPS}" = "yes" ] || [ "${HTTPS}" = "true" ]; then
  args="${ARGS} -S"
fi
if [ ! -z "${OUTPUT_DIRECTORY}" ]; then
  args="${args} -o ${OUTPUT_DIRECTORY}"
fi
if [ ! -z "${DOMAIN}" ]; then
  args="${ARGS} -d ${DOMAIN}"
fi
if [ ! -z "${SLUG_SIZE}" ]; then
  args="${ARGS} -s ${SLUG_SIZE}"
fi
if [ ! -z "${BUFFER_SIZE}" ]; then
  args="${ARGS} -B ${BUFFER_SIZE}"
fi
if [ ! -z "${LOG_FILE}" ]; then
  args="${ARGS} -b ${LOG_FILE}"
fi

nginx -g 'daemon off;'

/usr/local/bin/fiche "${args}" &
FICHE_PID=$!

# Close trap function
close() {
  kill -SIGTERM "$FICHE_PID"
}

# Trap SIGTERM and SIGINT
trap "close" SIGTERM
trap "close" SIGINT

# Wait for Fiche (in case it crashes, etc)
wait "$FICHE_PID"
