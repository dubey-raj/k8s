# k8s
Create and deploy Kubernetes workloads using different cloud providers

Source code is arranged as below file structure.<br>
```console
usermanagement(dotnet web api)
│   Dockerfile
infrastructure(contains yaml files for kubernetes)
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
```

<br>
[Docker hub URL](https://hub.docker.com/repository/docker/dubeyraj/usermanager/general)<br>
[API URL](http://34.139.140.232/swagger)