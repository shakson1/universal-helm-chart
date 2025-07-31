
# Universal Helm Chart

A comprehensive Helm chart that can deploy any type of Kubernetes application including Deployments, DaemonSets, and StatefulSets with full support for all Kubernetes features.

## Features

### 🚀 Workload Types
- **Deployment** - For stateless applications
- **DaemonSet** - For node-level applications (logging, monitoring)
- **StatefulSet** - For stateful applications with persistent storage

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
- **Service Accounts** - Custom service accounts with annotations
- **Secrets** - Multiple secrets with different types
- **ConfigMaps** - Configuration management
- **Pod Security Context** - Security policies

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
  --set replicaCount=3 \
  --set persistentVolumeClaims[0].name=data \
  --set persistentVolumeClaims[0].accessModes[0]=ReadWriteOnce \
  --set persistentVolumeClaims[0].resources.requests.storage=10Gi
```

## Configuration

### Workload Type

```yaml
# Choose your workload type
kind: Deployment  # or DaemonSet or StatefulSet
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

- Kubernetes 1.19+
- Helm 3.0+
- For VPA: Vertical Pod Autoscaler controller installed
- For Network Policies: CNI that supports Network Policies

## Contributing

This chart is designed to be universal and extensible. Feel free to contribute additional features or improvements.

## License

This project is licensed under the MIT License.