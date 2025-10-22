
# Universal Helm Chart

[![Version](https://img.shields.io/badge/version-1.2.0-blue.svg)](https://github.com/shakokakhadze/universal-helm-chart)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.19%2B-blue.svg)](https://kubernetes.io)
[![Helm](https://img.shields.io/badge/Helm-3.0%2B-blue.svg)](https://helm.sh)

## 🎯 One Chart to Rule Them All

A **production-ready, enterprise-grade** Helm chart that deploys any Kubernetes workload with zero compromises. Stop maintaining dozens of similar charts – use one universal chart that adapts to your needs.

### Why Universal Chart?

**🚀 All Workload Types** - Deploy anything: Deployments, StatefulSets, DaemonSets, Jobs, CronJobs  
**🔐 Security First** - Built-in RBAC, cloud IAM integration, and security best practices  
**♻️ DRY & Maintainable** - 95% less code duplication through intelligent design  
**☁️ Cloud Native** - Works seamlessly with AWS EKS, GCP GKE, Azure AKS  
**📈 Production Tested** - Battle-tested configurations following Kubernetes best practices  
**🔄 100% Compatible** - Backward compatible and works across K8s 1.19+

Perfect for teams that want **standardized, maintainable deployments** without sacrificing flexibility.

---

## 🚀 Quick Start

```bash
# Deploy a web application
helm install my-app oci://ghcr.io/shakson1/universal-helm-chart \
  --set containers[0].name=web \
  --set containers[0].image.repository=nginx \
  --set containers[0].image.tag=latest

# Deploy a database with persistent storage
helm install postgres . \
  --set kind=StatefulSet \
  --set persistentVolumeClaims[0].name=data \
  --set persistentVolumeClaims[0].resources.requests.storage=10Gi

# Run a scheduled backup job
helm install backup . \
  --set kind=CronJob \
  --set cronJob.schedule="0 2 * * *"
```

[Jump to detailed examples ↓](#quick-start)

---

## ✨ What's New in v1.2.0

This production-ready release brings enterprise-grade features and significant code improvements:

### 🚀 New Workload Types
- **Job Support** - One-time batch processing tasks with retry logic and TTL cleanup
- **CronJob Support** - Scheduled/recurring tasks with timezone support and concurrency control

### 🔐 Security & RBAC
- **Full RBAC Implementation** - Role, RoleBinding, ClusterRole, ClusterRoleBinding support
- **Cloud IAM Integration** - Native support for AWS IRSA and GCP Workload Identity
- **Enhanced Service Accounts** - Auto-mount control and cloud provider annotations

### ♻️ Code Quality & Maintainability
- **95% Code Reduction** - Eliminated ~1,000 lines through DRY principles
- **Shared Pod Template** - Single source of truth for all workload types
- **13 New Helper Functions** - Following Helm and Kubernetes best practices
- **API Version Auto-detection** - Automatic compatibility across K8s versions

### 🔧 Advanced Workload Management
- **Update Strategies** - Fine-grained control over Deployment, DaemonSet, and StatefulSet rollouts
- **Revision History** - Configure rollback capabilities with revisionHistoryLimit
- **Min Ready Seconds** - Ensure pod stability before marking as ready
- **StatefulSet Enhancements** - podManagementPolicy and enhanced PVC configurations

### 📋 Developer Experience
- **Post-Install Guidance** - NOTES.txt with helpful commands and troubleshooting tips
- **Lifecycle Hooks** - Full support for postStart and preStop hooks
- **Comprehensive Examples** - Real-world configurations for all workload types
- **Enhanced Documentation** - Complete examples for RBAC, Jobs, CronJobs, and more

### 🎯 Production-Ready Features
- ✅ **100% Backward Compatible** - No breaking changes from v1.0.x
- ✅ **Helm Lint Clean** - Zero errors or warnings
- ✅ **Multi-Cluster Ready** - Tested on Kubernetes 1.19+
- ✅ **Cloud Native** - AWS EKS, GCP GKE, Azure AKS compatible

[See detailed changelog](IMPROVEMENTS_v1.1.0.md)

---

## 💡 Use Cases

This chart is perfect for:

### 👥 **Development Teams**
- Standardize deployments across microservices
- Reduce chart maintenance overhead by 90%
- Onboard new developers faster with consistent patterns

### 🏢 **Platform Teams**
- Provide a golden path for application deployment
- Enforce security and compliance standards
- Support multiple workload types without multiple charts

### 🔧 **DevOps Engineers**
- Deploy anything from simple apps to complex StatefulSets
- Integrate with cloud IAM (AWS IRSA, GCP Workload Identity)
- Manage scheduled jobs and batch processing

### 📊 **Real-World Examples**
- **Web Apps** → Deployment with Ingress and HPA
- **Databases** → StatefulSet with persistent storage
- **Data Processing** → Jobs with resource limits and TTL cleanup
- **Scheduled Tasks** → CronJobs for backups, reports, maintenance
- **Monitoring Agents** → DaemonSets running on every node
- **API Services** → Multi-container apps with sidecars

---

## Features

### 🚀 Workload Types
- **Deployment** - For stateless applications
- **DaemonSet** - For node-level applications (logging, monitoring)
- **StatefulSet** - For stateful applications with persistent storage
- **Job** - For one-time batch processing tasks ⭐ NEW
- **CronJob** - For scheduled/recurring tasks ⭐ NEW

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
- **RBAC** - Full Role-Based Access Control with Role/ClusterRole ⭐ NEW
- **Service Accounts** - Custom service accounts with cloud IAM integration
- **Secrets** - Multiple secrets with different types
- **ConfigMaps** - Configuration management
- **Pod Security Context** - Security policies
- **Cloud IAM** - AWS IRSA, GCP Workload Identity support ⭐ NEW

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