# kubespray cluster on Hetzner Cloud

```sh
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dash-user | awk '{print $1}')
```
