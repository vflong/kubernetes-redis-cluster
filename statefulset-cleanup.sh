kubectl delete -f persistentvolume
kubectl delete -f persistentvolumeclaims
kubectl delete cm redis-conf
kubectl delete -f statefulset-services
kubectl delete -f statefulset

