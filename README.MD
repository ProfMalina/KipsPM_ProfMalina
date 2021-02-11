#Pre-requisites:
1. terraform 0.13.6
2. Yandex CLI
3. helm3.5

#Install guide
1. Install Kubernetes cluster on YandexCloud
  - cd kubernetes/terraform/prod
  - terraform init
  - terraform apply -auto-approve
  - yc managed-kubernetes cluster get-credentials otus-cluster --external

2. Install GitLab
  - cd gitlab-install/terraform
  - terraform init
  - terraform apply -auto-approve
  - cd gitlab-install/ansible
  - ansible-playbook playbooks/update.yml
  - ansible-playbook playbooks/gitlab.yml
  - login/password for gitlab: root/5iveL!fe  ###Change immediately!

3. Configure GitLab&Kubernetes
  - kubectl apply -f gitlab-admin-service-account.yaml
  - Configure in gitlab web interface
  - Cluster id `yc managed-kubernetes cluster list --format=json | jq -r .[].id`
  - API URL `yc managed-kubernetes cluster get $(yc managed-kubernetes cluster list --format=json | jq -r .[].id) --format=json | jq -r .master.endpoints.external_v4_endpoint`
  - CA Certificate `yc managed-kubernetes cluster get $(yc managed-kubernetes cluster list --format=json | jq -r .[].id) --format=json | jq -r .master.master_auth.cluster_ca_certificate`
  - Service Token `kubectl -n kube-system get secrets -o json | jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | base64 --decode`
  - add `CI_REGISTRY_USER CI_REGISTRY_PASSWORD KUBE_TOKEN KUBE_URL SEARCH_ENGINE_DEPLOY_TRIGGER_TOKEN`
  - install ingress
  - install gitlab-runner
  - use ingress endpoint as base domain
  - add secret for auth `kubectl create secret generic basic-auth --from-file=auth`

4. Add search_engine stack in gitlab
  - add ssh_key in gitlab
  - add blank projects
  - cd gitlab-ci/search_engine_deploy
  - git remote add origin git@gitlab.84.252.130.211.sslip.io:search_engine/search_engine_deploy.git
  - cd gitlab-ci/ui
  - git remote add origin git@gitlab.84.252.130.211.sslip.io:search_engine/ui.git
  - cd gitlab-ci/crawler
  - git remote add origin git@gitlab.84.252.130.211.sslip.io:search_engine/crawler.git

5. Install Prometheus&Grafana
  - change in values host
  - helm upgrade --install prometheus prometheus/
  - change in values host
  - helm upgrade --install grafana grafana/
  - on grafana web interface add data source `prometheus-server`
  - dashboard import 741 315

6. Install EFK stack
 - change in values kibana host
 - helm upgrade --install elastic-stack elastic-stack/
 - example `kubernetes.pod.name *staging-ui*`
