kubectl create -f persistentvolume
kubectl create -f persistentvolumeclaims
kubectl create configmap redis-conf --from-file=redis.conf --namespace=base
kubectl create -f statefulset-services
kubectl create -f statefulset

