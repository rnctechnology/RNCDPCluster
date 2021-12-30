FROM gcr.io/spark-operator/spark-py:v2.4.5

RUN rm $SPARK_HOME/jars/guava-14.0.1.jar
ADD https://repo1.maven.org/maven2/com/google/guava/guava/28.0-jre/guava-28.0-jre.jar $SPARK_HOME/jars

ADD https://repo1.maven.org/maven2/com/google/cloud/bigdataoss/gcs-connector/hadoop2-2.0.1/gcs-connector-hadoop2-2.0.1-shaded.jar $SPARK_HOME/jars

ENTRYPOINT [ "/opt/entrypoint.sh" ]