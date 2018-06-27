kubectl delete -f statefulset -n base
kubectl delete -f statefulset-services -n base
kubectl delete cm redis-conf -n base
kubectl delete -f persistentvolumeclaims -n base
kubectl delete -f persistentvolume
