#!/bin/bash

# Inicio - Filebeat init
# -----------------------------------------------------
SERVER=`hostname`
NAME=filebeat
FILEBEAT_HOME="/opt/elk/filebeat"
FILEBEAT_CONFIG=${FILEBEAT_HOME}/filebeat_logfiles_"$SERVER".yml
if [[ ! -f ${FILEBEAT_CONFIG} ]]; then
  echo "Erro - Nao foi possivel encontrar arquivo de configuracao do FileBeat em ${FILEBEAT_CONFIG}"
  exit 1
fi

PID=`ps -ef | grep filebeat_logfiles_"${SERVER}".yml | grep -v grep | awk '{print $2}'`

start() {
  # Start metricbeat
  if [[ -n "${PID}" ]]; then
    echo "FileBeat is already running at '${SERVER}' (${PID})"
    return 0
  fi

  echo "Starting FileBeat at '${SERVER}..."
  ${FILEBEAT_HOME}/filebeat -c $FILEBEAT_CONFIG > /dev/null 2>&1 &
  return 0
}

stop() {
  if [[ -n "${PID}" ]]; then
    echo "Shutting down Filebeat at '${SERVER}' (${PID})"
    kill -9 ${PID}
  else
    echo "Filebeat is not running at '${SERVER}'"
  fi
  return 0
}

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        if [[ -n "${PID}" ]]
        then
           echo "Filebeat is running at '${SERVER}' with PID: ${PID}"
        else
           echo "Filebeat is not running at '${SERVER}'"
        fi
        ;;
    *)
        echo $"Usage: $NAME {start|stop|restart|status}"
esac

exit 0

