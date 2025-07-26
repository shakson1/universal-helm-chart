
# Universal Helm Chart

A highly flexible Helm chart capable of deploying various Kubernetes workloads—`Deployment`, `StatefulSet`, or `DaemonSet`—with optional support for Ingress, HPA, ConfigMaps, environment variables, and more.

---

## ✅ Features

- Deploy as `Deployment`, `StatefulSet`, or `DaemonSet` based on the `kind` value
- Optional Ingress support with customizable annotations and TLS
- Integrated Horizontal Pod Autoscaling (HPA)
- Supports environment variables, volume mounts, node selectors, affinity, and tolerations
- Optional ConfigMap creation and mounting

---

## 📦 Prerequisites

- Helm 3.x installed
- A running Kubernetes cluster

---

## 🚀 Installation

To install the chart with default settings:

```bash
helm install my-app ./ --values values.yaml
```

To uninstall the release:

```bash
helm uninstall my-app
```

---

## 🔧 Configuration

The following table outlines the configurable parameters in `values.yaml`:

| Parameter                  | Type    | Description                                                | Default       |
|---------------------------|---------|------------------------------------------------------------|---------------|
| `kind`                    | string  | Workload type: `Deployment`, `StatefulSet`, or `DaemonSet` | `Deployment`  |
| `replicaCount`            | int     | Number of replicas (only applies to Deployment)            | `2`           |
| `image.repository`        | string  | Container image repository                                 | `nginx`       |
| `image.tag`               | string  | Container image tag                                        | `latest`      |
| `service.enabled`         | bool    | Whether to create a service                                | `true`        |
| `service.type`            | string  | Kubernetes service type                                    | `ClusterIP`   |
| `ingress.enabled`         | bool    | Enable Ingress resource                                    | `false`       |
| `hpa.enabled`             | bool    | Enable Horizontal Pod Autoscaler                           | `false`       |
| `env`                     | list    | Environment variables to inject into the container         | `[]`          |
| `resources`               | object  | Resource requests and limits                               | `{}`          |
| `volumeMounts`, `volumes`| list    | Volume mounts and volume definitions                       | `[]`          |
| `nodeSelector`            | object  | Node selector rules                                        | `{}`          |
| `tolerations`             | list    | Tolerations for scheduling                                 | `[]`          |
| `affinity`                | object  | Affinity settings                                          | `{}`          |
| `serviceAccount.name`     | string  | Service account name to use                                | `default`     |
| `configmap.enabled`       | bool    | Whether to create a ConfigMap                              | `false`       |

---

## 📂 Example `values.yaml`

```yaml
kind: Deployment

replicaCount: 2

image:
  repository: nginx
  tag: stable

service:
  enabled: true
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: nginx
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
  hosts:
    - host: example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - hosts:
        - example.com
      secretName: example-tls
```

---

## 🧩 License

MIT