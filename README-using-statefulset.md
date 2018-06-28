# Kubernetes Redis Cluster

### Create NFS storages
#### 安装软件
 
```bash
# server/client
yum -y install nfs-utils
# start
systemctl enable nfs-server.service
systemctl start nfs-server.service
```
 
#### 配置目录
 
```bash
# 新建子目录后需再次执行 chown/chmod
mkdir -p /data/nfs/n{1..6}
chown -R nfsnobody. /data/nfs
chmod -R 755 /data/nfs
cat /etc/exports
### content start ###
# 下面的地址为 client 地址
/data/nfs        192.168.1.101(rw,sync,no_subtree_check)
### content end ###
# make change
exportfs -a
```
 
#### 挂载
 
```bash
mkdir -p /mnt/nfs
mount 192.168.1.101:/data/nfs /mnt/nfs
df -h
mount
```

### Create Persistent Volumes

```
kubectl create -f persistentvolume
```

### Create Persistent Volumes Claims

```
kubectl create -f persistentvolumeclaims
```

### Create Redis Cluster Configuration

```
kubectl create configmap redis-conf --from-file=redis.conf
```

### Create Redis Services

```
kubectl create -f statefulset-services
```

### Create Redis Statefulset

```
kubectl create -f statefulset/redis-statefulset.yaml
```

### Connect Nodes

```
# kubectl run -i --tty ubuntu --image=ubuntu --restart=Never /bin/bash
# apt-get update
# apt-get install -y vim wget python2.7 python-pip redis-tools dnsutils

kubectl run -i  --tty ubuntu --image=vflong/redis-trib --restart=Never /bin/bash
```


*Note:* `redis-trib` doesn't support hostnames (see [this issue](https://github.com/antirez/redis/issues/2565)), so we use `dig` to resolve our cluster IPs.

```
pip install redis-trib
```

```
redis-trib.py create \
  `dig +short redis-app-0.redis-service.default.svc.cluster.local`:6379 \
  `dig +short redis-app-1.redis-service.default.svc.cluster.local`:6379 \
  `dig +short redis-app-2.redis-service.default.svc.cluster.local`:6379

redis-trib.py replicate \
  --master-addr `dig +short redis-app-0.redis-service.default.svc.cluster.local`:6379 \
  --slave-addr `dig +short redis-app-3.redis-service.default.svc.cluster.local`:6379
redis-trib.py replicate \
  --master-addr `dig +short redis-app-1.redis-service.default.svc.cluster.local`:6379 \
  --slave-addr `dig +short redis-app-4.redis-service.default.svc.cluster.local`:6379
redis-trib.py replicate \
  --master-addr `dig +short redis-app-2.redis-service.default.svc.cluster.local`:6379 \
  --slave-addr `dig +short redis-app-5.redis-service.default.svc.cluster.local`:6379
```

### Accessing redis cli

Connect to any redis pod
```
kubectl exec -it <podName> -- /bin/bash
```
Access cli
```
/usr/local/bin/redis-cli -c -p 6379
```
To check cluster nodes
```
/usr/local/bin/redis-cli -p 6379 cluster nodes
```


### Contribs

```
Originally contributed by Kelsey Hightower (https://github.com/kelseyhightower/kubernetes-redis-cluster)
```
