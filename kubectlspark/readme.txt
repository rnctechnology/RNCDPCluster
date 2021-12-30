-- 1, setup pvc

kubectl create -f spark-data-pvc.yaml
kk get pvc spark-data

===not used
echo "how much wood could a woodpecker chuck if a woodpecker could chuck wood" > /tmp/test.txt
kubectl cp /tmp/my.jar spark-data-pod:/data/my.jar
kubectl cp /tmp/test.txt spark-data-pod:/data/test.txt
kubectl exec -it spark-data-pod -- ls -al /data
Delete the pod, as it is not longer required:
kubectl delete pod spark-data-pod
===not used

-- 2, create service

kubectl create -f spark-service.yml
kk get svc spark-master

-- 3, create deployment
kubectl create -f spark-deployment.yml

--for update
kk scale deployment spark-master --replicas=0
kubectl apply -f spark-deployment.yml

-- 4, build docker
docker build -t rnctech/rnctechsvc:lastest -f Dockerfile.spark .

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