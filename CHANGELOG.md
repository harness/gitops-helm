# Changelog

## 1.2.0

This upgrade contains upgrade of [argo-cd v9.0.0](https://github.com/argoproj/argo-helm/blob/argo-cd-9.0.0/charts/argo-cd/Chart.yaml) helm chart.

Please refer to [changelog](https://github.com/argoproj/argo-helm/blob/argo-cd-9.0.0/charts/argo-cd/README.md#900) for possible breaking changes.

Additionally in order to preserve backward compatibility with argo v2 behaviour the following argocd cm configurations were provided as part of `values.yaml`:

```yaml
      application.resourceTrackingMethod: "label"
      resource.compareoptions: |
        ignoreResourceStatusField: crd
```

as per the argocd v2->v3 migration [guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.14-3.0/)
