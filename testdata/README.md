To generate manifest.yaml

run from charts directory - 

helm template argocd .  --namespace test --set argo-cd.crds.install=true  --set argo-cd.redisSecretInit.enabled=false --set argo-cd.applicationSet.enabled=true --set argo-cd.commitServer.enabled=true > ./../testdata/manifest.yaml