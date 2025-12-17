# GitOps Agent Helm Charts

This repository contains Helm charts for installing Harness GitOps Agents.

The charts can be added using following command:
```bash
helm repo add gitops-agent https://harness.github.io/gitops-helm/
```

Please refer to [Install a Harness GitOps Agent](https://developer.harness.io/docs/continuous-delivery/gitops/use-gitops/install-a-harness-git-ops-agent) for the steps needed to create and manage your agent installations.

This repository is maintained at [gitops-helm](https://github.com/harness/gitops-helm) by [Harness](http://harness.io/).

For further support to override your Argo CD components, refer to [Argo CD's values.yaml](https://github.com/argoproj/argo-helm/blob/main/charts/argo-cd/values.yaml) file.

## Using Existing Secrets

Instead of creating new secrets, you can use existing secrets by specifying them in the `agent.existingSecrets` section of your values file:

```yaml
agent:
  existingSecrets:
    # Existing secret for agent token (must contain GITOPS_AGENT_TOKEN key)
    agentToken: "my-agent-token-secret"
    
    # Existing secret for CA bundle (must contain ca.bundle key)
    caBundle: "my-ca-bundle-secret"
    
    # Existing secret for mTLS client certificate and key (must contain client.crt and client.key keys)
    mtls: "my-mtls-secret"
```

This allows you to manage your secrets separately from the Helm chart installation.

## Troubleshooting
Common trobleshooting questions can be found [here](https://developer.harness.io/docs/continuous-delivery/gitops/resources/troubleshooting/)