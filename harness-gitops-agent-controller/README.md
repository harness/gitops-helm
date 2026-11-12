# Harness GitOps Agent Controller Helm Chart

Deploys the `harness-gitops-agent-operator` controller manager and two CRDs:

- `HarnessGitopsAgent` owns one Harness agent registration and its token Secret.
- `HarnessGitopsProjectMapping` owns or observes one Argo CD AppProject to
  Harness project mapping and references an Agent in the same namespace.

Keeping mappings as separate resources lets one Agent serve many Harness
projects while each mapping has independent readiness, ownership, drift
handling, and finalization.

## Prerequisites

- Kubernetes >= 1.25
- Cluster-admin for the install (the chart installs two cluster-scoped CRDs)
- A published controller image (`image.repository` / `image.tag`)

## Installing the chart

```bash
helm upgrade --install hgac charts/harness-gitops-agent-controller \
  --namespace hga-system --create-namespace \
  --values my-values.yaml
```

Installs both CRDs and the controller together; a later `helm upgrade` updates
all three resources.

## Uninstalling the chart

```bash
helm uninstall hgac -n hga-system
```

With the default `crds.keep=true`, both CRDs carry
`helm.sh/resource-policy: keep`, so their instances survive uninstall. When
`crds.keep=false`, Helm may remove the CRDs and every corresponding Kubernetes
resource. Delete Mapping CRs and Agent CRs while the controller is running if
their finalizers should clean up managed Harness resources.
Controller-created and explicitly adopted resources are deleted remotely;
external resources are left in Harness.

Deleting either CRD deletes every Kubernetes object of that kind. Only do that
after deleting its CRs and confirming their finalizers completed:

```bash
kubectl delete crd \
  harnessgitopsprojectmappings.gitops.harness.io \
  harnessgitopsagents.gitops.harness.io
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `crds.enabled` | bool | `true` | Install both Harness GitOps CRDs with the chart. Set `false` to manage them out-of-band. |
| `crds.keep` | bool | `true` | Annotate both CRDs with `helm.sh/resource-policy: keep` so `helm uninstall` never deletes them. |
| `replicaCount` | int | `1` | Controller replicas. Use `>= 2` with a PDB for HA. |
| `image.repository` | string | `harness/gitops-agent-bootstrap-controller` | Controller image repository. |
| `image.tag` | string | `v0.1.0` | Image tag. Pin to an immutable tag in production. |
| `image.pullPolicy` | string | `IfNotPresent` | Image pull policy. |
| `rbac.create` | bool | `true` | Create the controller ClusterRole and binding. |
| `serviceAccount.create` | bool | `true` | Create the controller ServiceAccount. |
| `leaderElection.enabled` | bool | `true` | Enable leader election (required for HA). |
| `manager.apiKeySecretNamespace` | string | `""` | Namespace to read each `apiKeySecretRef` from. Empty resolves to the controller Helm release namespace. |
| `manager.appProjectPendingRetryInterval` | string | `20s` | Requeue interval while an AppProject/agent is not yet ready. |
| `manager.harnessMappingResyncInterval` | string | `5m` | Interval to re-verify a ready mapping against Harness. |
| `manager.metrics.bindAddress` | string | `"0"` | Metrics bind address (`"0"` disables the endpoint). |
| `manager.metrics.secure` | bool | `true` | Serve metrics over HTTPS with authn/authz. |
| `manager.enableHTTP2` | bool | `false` | Enable HTTP/2 (kept off for CVE mitigation). |
| `manager.zapDevelopment` | bool | `true` | Development-mode logging. Set `false` for JSON logs in production. |
| `podDisruptionBudget.enabled` | bool | `false` | Create a PodDisruptionBudget. |
| `resources` | object | see `values.yaml` | Controller resource requests/limits. |

See [`values.yaml`](./values.yaml) for the full list (probes, securityContext,
nodeSelector, tolerations, affinity, topology spread).

## Production notes

- Pin `image.tag` to an immutable tag.
- Set `manager.zapDevelopment=false` for JSON logs.
- HA: `replicaCount >= 2`, `podDisruptionBudget.enabled=true`, `leaderElection.enabled=true`.
- Keep `manager.apiKeySecretNamespace` empty to read API keys from the
  controller Helm release namespace, or set an explicit central namespace.
  This keeps cleanup credentials independent of workload namespace deletion.
