-- 0, prepare role and persistence volumn

0.1, create and binding role
(spark-submit --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark)

kubectl apply -f spark_user_binding.yaml

or directly create using cmd below:

kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit --serviceaccount=default:spark --namespace=default

0.2, create storageClass or using cloud storage

for local fs,  on nodes

mkdir -p /mnt/data
kubectl apply -f pv.yaml

-- 1, setup pvc

kubectl create -f spark-pvc.yaml
kubectl create -f mariadb-pvc.yaml
kk get pvc

===not used
echo "how much wood could a woodpecker chuck if a woodpecker could chuck wood" > /tmp/test.txt
kubectl cp /tmp/my.jar spark-data-pod:/data/my.jar
kubectl cp /tmp/test.txt spark-data-pod:/data/test.txt
kubectl exec -it spark-data-pod -- ls -al /data
Delete the pod, as it is not longer required:
kubectl delete pod spark-data-pod
===not used

-- 2, create service

kubectl create -f spark-master-service.yml
kubectl create -f spark-worker-1-service.yml
kubectl create -f spark-worker-2-service.yml
kk get svc

-- 3, create deployment
kubectl create -f spark-master-deployment.yml
kubectl create -f spark-worker-1-deployment.yml
kubectl create -f spark-worker-2-deployment.yml

--for update
kk scale deployment spark-deployment --replicas=0
kubectl apply -f spark-deployment.yml

-- 4, export port to external
kubectl apply -f spark-np.yaml

-- 98, build docker
docker build -t rnctech/spark:latest -f Dockerfile.spark .

#docker run -it -p 8888:8888 -p 8998:8998 -p 8080:8080 -e BATCH_FILE_TYPE=server rnctech/rnctechsvc:lastest

-- 99, loadBalancener?
service:
  type: LoadBalancer
worker:
  replicaCount: 3
  extraVolumes:
    - name: spark-data
      persistentVolumeClaim:
        claimName: spark-data-pvc
  extraVolumeMounts:
    - name: spark-data
      mountPath: /data