#!/bin/bash


PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
BASENAME="${0##*/}"
BATCH_FILE_TYPE="server"

run_server () {
  # work around for kubenetes cluster
   unset SPARK_MASTER_PORT
   export SPARK_MASTER_PORT=7077

  echo "export PATH=~/.local/bin:$PATH" >> /home/jovyan/.bashrc
  nodeType="${SPARK_MODE:-worker}"

  if [[ "${SPARK_MODE=master}" == "master" ]]; then
      echo "$(hostname -i) spark-master" >> /etc/hosts
      ${SPARK_HOME}/sbin/start-master.sh -h spark-master
        # run livy server
      ${LIVY_HOME}/bin/livy-server start --master spark://spark-master:7077

      # start notebook (port:8888)
      cd $HOME/

      /opt/conda/bin/python3.9 /opt/conda/bin/jupyter-notebook
  else
      sleep 60
      x=0
      while ! getent hosts spark-master; do
        if [[ $x -ge 60 ]]; then
          echo "Cannot resolve the DNS entry for spark-master. Exit"
          exit 0
        fi

        echo "Waiting 20s ......"
        sleep 20
        x=$(( $x + 1 ))
      done

      #${SPARK_HOME}/sbin/start-worker.sh spark://spark-master:7077
      ${SPARK_HOME}/sbin/start-slave.sh spark://spark-master:7077

      cd $HOME
      sleep infinity

  fi

}

run_server "${@}"
