#!/bin/bash


PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
BASENAME="${0##*/}"
BATCH_FILE_TYPE="server"

run_server () {
  echo "export PATH=~/.local/bin:$PATH" >> /home/jovyan/.bashrc

  # run spark standalone cluster
  ${SPARK_HOME}/sbin/start-master.sh -h localhost
  ${SPARK_HOME}/sbin/start-slave.sh spark://localhost:7077
  
  # run livy server
  ${LIVY_HOME}/bin/livy-server start --master spark://localhost:7077

  # start notebook (port:8888)
  cd $HOME/

  /opt/conda/bin/python3.9 /opt/conda/bin/jupyter-notebook
}

run_server "${@}"
