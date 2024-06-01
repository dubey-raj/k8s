# k8s
Create and deploy Kubernetes workloads using different cloud providers
<br>
[Code Repository](https://github.com/dubey-raj/k8s/tree/master/infrastructure)<br>
[Docker hub](https://hub.docker.com/repository/docker/dubeyraj/usermanager/general)<br>
[Service API](http://127.0.0.1/swagger)

...bash
infrastructure
│   namespace.yaml
│
├───api
│       user-manager-api-deployment.yaml
│       user-manager-api-hpa.yaml
│       user-manager-api-svc.yaml
│
└───database
        postgres-configmap.yaml
        postgres-headless-svc.yaml
        postgres-secret.yaml
        postgres-statefulset.yaml
...