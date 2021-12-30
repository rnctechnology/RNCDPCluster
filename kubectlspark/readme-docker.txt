
1, build jar file and copy into ~/jars

2, build docker images
  docker build -f Dockerfile.spark -t rnctech/spark:latest .

3, run spark master
docker run -td --name loops-spark -p 8998:8998 -p 4040:4040 -p 8080:8080 rnctech/spark:latest

4, submit a job of sample PI

$SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://spark-master:7077 /opt/spark/examples/jars/spark-examples_2.12-3.2.0.jar 1000

5, test livy api
post -- localhost:8998/batches
{"file": "/tmp/TestPyPi.py"}
