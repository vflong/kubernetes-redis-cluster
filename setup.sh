kubectl create -f pvc-qa2
kubectl create configmap redis-conf --from-file=redis.conf --namespace=base
kubectl create -f statefulset-services
kubectl create -f statefulset

