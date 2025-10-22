
# Universal Helm Chart

[![Version](https://img.shields.io/badge/version-1.2.0-blue.svg)](https://github.com/shakokakhadze/universal-helm-chart)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A comprehensive, production-ready Helm chart that can deploy any type of Kubernetes application with full support for all Kubernetes features. This universal chart eliminates the need to maintain multiple chart templates by supporting all major workload types and features in a single, well-maintained chart.

## ✨ What's New in v1.1.0

- 🆕 **Job & CronJob Support** - Batch and scheduled workloads
- 🔐 **RBAC Support** - Full Role-Based Access Control
- ♻️ **Code Refactoring** - 95% reduction in code duplication
- 🔧 **Update Strategies** - Fine-grained control over rollouts
- 📋 **Post-Install Notes** - Helpful guidance after installation
- ☁️ **Cloud IAM Integration** - AWS IRSA, GCP Workload Identity support

[See full changelog](IMPROVEMENTS_v1.1.0.md)

## Features

### 🚀 Workload Types
- **Deployment** - For stateless applications
- **DaemonSet** - For node-level applications (logging, monitoring)
- **StatefulSet** - For stateful applications with persistent storage
- **Job** - For one-time batch processing tasks (NEW in v1.1.0)
- **CronJob** - For scheduled/recurring tasks (NEW in v1.1.0)

### 🔧 Container Support
- **Multiple Containers** - Support for main containers, init containers, and sidecar containers
- **Container Configuration** - Full container spec support including ports, env vars, resources, probes
- **Security Context** - Pod and container-level security contexts
- **Lifecycle Hooks** - Post-start and pre-stop hooks

### 🌐 Networking
- **Services** - Multiple port support with annotations
- **Ingress** - Full ingress configuration with TLS support
- **Network Policies** - Fine-grained network security controls

### 📊 Autoscaling
- **Horizontal Pod Autoscaler (HPA)** - CPU and memory-based scaling with custom behavior
- **Vertical Pod Autoscaler (VPA)** - Resource optimization (requires VPA controller)

### 💾 Storage
- **Volumes** - ConfigMap, Secret, EmptyDir, and custom volumes
- **Persistent Volume Claims** - For StatefulSets with storage classes
- **Volume Mounts** - Flexible volume mounting configuration

### 🔐 Security & RBAC
- **RBAC** - Full Role-Based Access Control with Role/ClusterRole (NEW in v1.1.0)
- **Service Accounts** - Custom service accounts with cloud IAM integration
- **Secrets** - Multiple secrets with different types
- **ConfigMaps** - Configuration management
- **Pod Security Context** - Security policies
- **Cloud IAM** - AWS IRSA, GCP Workload Identity support (NEW in v1.1.0)

### 🛡️ Availability
- **Pod Disruption Budget** - Availability guarantees during maintenance
- **Topology Spread Constraints** - Pod distribution across nodes/zones
- **Affinity/Anti-affinity** - Pod placement rules

### 🔍 Monitoring & Health
- **Health Probes** - Liveness, readiness, and startup probes
- **Resource Limits** - CPU and memory requests/limits
- **Annotations & Labels** - Custom metadata

## Quick Start

### Basic Deployment

```bash
# Deploy a simple nginx application
helm install my-app ./universal_chart \
  --set kind=Deployment \
  --set image.repository=nginx \
  --set image.tag=latest \
  --set replicaCount=3
```

### DaemonSet Example

```bash
# Deploy a logging agent on all nodes
helm install logging-agent ./universal_chart \
  --set kind=DaemonSet \
  --set image.repository=fluent/fluent-bit \
  --set image.tag=latest
```

### StatefulSet with Storage

```bash
# Deploy a database with persistent storage
helm install my-db ./universal_chart \
  --set kind=StatefulSet \
  --set image.repository=postgres \
  --set image.tag=13 \
  --set replicaCount=3
```

### Job Example (NEW)

```bash
# Run a one-time database migration job
helm install db-migration ./universal_chart \
  --set kind=Job \
  --set job.ttlSecondsAfterFinished=3600 \
  --set containers[0].name=migration \
  --set containers[0].image.repository=migrate/migrate \
  --set containers[0].image.tag=latest
```

### CronJob Example (NEW)

```bash
# Schedule daily backup at midnight
helm install daily-backup ./universal_chart \
  --set kind=CronJob \
  --set cronJob.schedule="0 0 * * *" \
  --set containers[0].name=backup \
  --set containers[0].image.repository=backup-tool \
  --set containers[0].image.tag=latest
```

### With RBAC (NEW)

```bash
# Deploy with RBAC permissions
helm install my-app ./universal_chart -f - <<EOF
kind: Deployment
rbac:
  create: true
  rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "list", "watch"]
serviceAccount:
  create: true
EOF
```

## Configuration

### Workload Type

```yaml
# Choose your workload type
kind: Deployment  # Deployment, DaemonSet, StatefulSet, Job, or CronJob
```

### Multiple Containers

```yaml
containers:
  - name: app
    image:
      repository: nginx
      tag: latest
    ports:
      - name: http
        containerPort: 80
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
    livenessProbe:
      httpGet:
        path: /health
        port: 80
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /ready
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5

  - name: sidecar
    image:
      repository: nginx
      tag: alpine
    ports:
      - name: metrics
        containerPort: 8080
```

### Init Containers

```yaml
initContainers:
  - name: init-db
    image:
      repository: busybox
      tag: "1.28"
    command:
      - sh
      - -c
      - "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done;"
```

### Service Configuration

```yaml
service:
  enabled: true
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 80
      protocol: TCP
    - name: https
      port: 443
      targetPort: 443
      protocol: TCP
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
```

### Ingress Configuration

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - hosts:
        - app.example.com
      secretName: app-tls
```

### Horizontal Pod Autoscaler

```yaml
hpa:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
```

### Persistent Volume Claims (StatefulSet)

```yaml
persistentVolumeClaims:
  - name: data
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
    storageClassName: fast-ssd
  - name: logs
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 5Gi
```

### ConfigMaps and Secrets

```yaml
configMaps:
  - name: app-config
    data:
      config.yaml: |
        environment: production
        log_level: info
        database:
          host: db.example.com
          port: 5432

secrets:
  - name: app-secrets
    type: Opaque
    stringData:
      username: admin
      password: secret123
  - name: tls-secret
    type: kubernetes.io/tls
    data:
      tls.crt: LS0tLS1CRUdJTi...
      tls.key: LS0tLS1CRUdJTi...
```

### RBAC Configuration (NEW in v1.1.0)

```yaml
# Enable RBAC
rbac:
  create: true
  clusterWide: false  # Set to true for ClusterRole instead of Role
  rules:
    - apiGroups: [""]
      resources: ["pods", "configmaps"]
      verbs: ["get", "list", "watch"]
    - apiGroups: ["apps"]
      resources: ["deployments"]
      verbs: ["get", "list"]

serviceAccount:
  create: true
  annotations:
    # AWS IAM Role for Service Account (IRSA)
    eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT_ID:role/IAM_ROLE_NAME
    # GCP Workload Identity
    # iam.gke.io/gcp-service-account: GSA_NAME@PROJECT_ID.iam.gserviceaccount.com
```

### Job Configuration (NEW in v1.1.0)

```yaml
kind: Job

job:
  backoffLimit: 6                    # Number of retries
  completions: 1                     # Number of successful completions
  parallelism: 1                     # Parallel pods
  activeDeadlineSeconds: 3600        # Timeout (1 hour)
  ttlSecondsAfterFinished: 86400     # Cleanup after 24 hours
  suspend: false

containers:
  - name: migration
    image:
      repository: migrate/migrate
      tag: latest
    command:
      - migrate
      - -path=/migrations
      - -database=postgres://...
      - up
```

### CronJob Configuration (NEW in v1.1.0)

```yaml
kind: CronJob

cronJob:
  schedule: "0 2 * * *"              # Daily at 2 AM
  timeZone: "America/New_York"       # Requires K8s 1.24+
  concurrencyPolicy: Forbid          # Don't run concurrent jobs
  suspend: false
  startingDeadlineSeconds: 300
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 1

job:
  backoffLimit: 3
  ttlSecondsAfterFinished: 3600      # Cleanup after 1 hour

containers:
  - name: backup
    image:
      repository: backup-tool
      tag: latest
    env:
      - name: BACKUP_TARGET
        value: s3://my-bucket/backups
```

### Update Strategy (NEW in v1.1.0)

```yaml
# For Deployment (RollingUpdate or Recreate)
updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0

# For DaemonSet
updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 1

# For StatefulSet
updateStrategy:
  type: RollingUpdate
  rollingUpdate:
    partition: 0  # Update all pods

revisionHistoryLimit: 10  # Number of old versions to keep
minReadySeconds: 0        # Wait time before marking pod ready
```

### Network Policy

```yaml
networkPolicy:
  enabled: true
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              name: ingress-nginx
      ports:
        - protocol: TCP
          port: 80
  egress:
    - to:
        - namespaceSelector: {}
      ports:
        - protocol: TCP
          port: 53
```

### Pod Disruption Budget

```yaml
pdb:
  enabled: true
  minAvailable: 1
  # or maxUnavailable: 1
```

### Affinity and Anti-affinity

```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - my-app
        topologyKey: kubernetes.io/hostname
```

### Security Context

```yaml
podSecurityContext:
  fsGroup: 2000
  runAsNonRoot: true
  runAsUser: 1000
  runAsGroup: 3000

containerSecurityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
  privileged: false
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000
```

## Advanced Examples

### Multi-container Application with Sidecar

```yaml
kind: Deployment
replicaCount: 3

containers:
  - name: app
    image:
      repository: myapp
      tag: v1.0.0
    ports:
      - name: http
        containerPort: 8080
    env:
      - name: DATABASE_URL
        valueFrom:
          secretKeyRef:
            name: db-secret
            key: url
    volumeMounts:
      - name: config
        mountPath: /etc/config
        readOnly: true
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"

  - name: sidecar
    image:
      repository: prom/prometheus
      tag: v2.30.0
    ports:
      - name: metrics
        containerPort: 9090
    volumeMounts:
      - name: prometheus-config
        mountPath: /etc/prometheus

volumes:
  - name: config
    configMap:
      name: app-config
  - name: prometheus-config
    configMap:
      name: prometheus-config

service:
  enabled: true
  ports:
    - name: http
      port: 8080
      targetPort: 8080
    - name: metrics
      port: 9090
      targetPort: 9090

ingress:
  enabled: true
  hosts:
    - host: app.example.com
      paths:
        - path: /
          pathType: Prefix
```

### StatefulSet with Multiple PVCs

```yaml
kind: StatefulSet
replicaCount: 3

containers:
  - name: database
    image:
      repository: postgres
      tag: "13"
    env:
      - name: POSTGRES_DB
        value: myapp
      - name: POSTGRES_USER
        valueFrom:
          secretKeyRef:
            name: db-secret
            key: username
      - name: POSTGRES_PASSWORD
        valueFrom:
          secretKeyRef:
            name: db-secret
            key: password
    volumeMounts:
      - name: data
        mountPath: /var/lib/postgresql/data
      - name: logs
        mountPath: /var/log/postgresql
      - name: config
        mountPath: /etc/postgresql

persistentVolumeClaims:
  - name: data
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 20Gi
    storageClassName: fast-ssd
  - name: logs
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 10Gi
    storageClassName: standard

volumes:
  - name: config
    configMap:
      name: postgres-config

service:
  enabled: true
  ports:
    - name: postgres
      port: 5432
      targetPort: 5432

pdb:
  enabled: true
  minAvailable: 2
```

## Values Reference

See the `values.yaml` file for a complete list of all available configuration options with examples and comments.

## Requirements

- **Kubernetes:** 1.19+
- **Helm:** 3.0+
- **Optional:**
  - VPA: Vertical Pod Autoscaler controller for VPA support
  - Network Policies: CNI plugin that supports Network Policies (e.g., Calico, Cilium)
  - RBAC: Enabled in cluster (default in most clusters)

## Installation

### From Source

```bash
# Clone the repository
git clone https://github.com/shakokakhadze/universal-helm-chart.git
cd universal-helm-chart

# Install the chart
helm install my-release .

# Or with custom values
helm install my-release . -f my-values.yaml
```

### Upgrade

```bash
# Upgrade to latest version
helm upgrade my-release . --reuse-values

# Upgrade with new values
helm upgrade my-release . -f my-values.yaml
```

### Uninstall

```bash
helm uninstall my-release
```

## Contributing

This chart is designed to be universal and extensible. Contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `helm lint` and `helm template`
5. Submit a pull request

## Changelog

See [IMPROVEMENTS_v1.1.0.md](IMPROVEMENTS_v1.1.0.md) for the latest changes.

## License

This project is licensed under the MIT License.

---

**Current Version:** 1.2.0  
**Maintainer:** Shako Kakhadze (shakokakhadze@gmail.com)  
**Repository:** https://github.com/shakokakhadze/universal-helm-chart