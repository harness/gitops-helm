To generate agent_manifest.yaml

run - 
helm template argocd .  --namespace test --set argo-cd.crds.install=true  --set argo-cd.redisSecretInit.enabled=false --set argo-cd.applicationSet.enabled=true --set argo-cd.commitServer.enabled=true > ./../testdata/agent_manifest.yaml