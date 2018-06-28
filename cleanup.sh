kubectl delete -f statefulset -n base
kubectl delete -f statefulset-services -n base
kubectl delete cm redis-conf -n base
kubectl delete -f pvc-qa2 -n base
