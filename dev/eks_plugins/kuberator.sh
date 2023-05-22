#kubectl create ns $1
PLUGIN_DIR="./"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#kubectl apply -f https://raw.githubusercontent.com/skooner-k8s/skooner/master/kubernetes-skooner.yaml
kubectl -n kube-system create -f kubernetes-k8dash.yaml
kubectl create -f k8dash-rbac.yaml

kubectl create ns mon
sleep 5
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install -f prometheus-values.yaml mon --namespace mon prometheus-community/kube-prometheus-stack --set prometheusOperator.createCustomResource=false
kubectl -n mon create cm es-p12-cert --from-file=elastic-stack-ca.p12
kubectl -n mon apply -f elasticsearch.yaml
kubectl -n mon apply -f filebeat.yaml
kubectl -n mon apply -f kibana.yaml
kubectl -n mon apply -f logstash.yaml
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.7.1 \
  --set installCRDs=true  \
  --set ingressShim.defaultIssuerName=letsencrypt-prod \
  --set ingressShim.defaultIssuerKind=ClusterIssuer \
  --set ingressShim.defaultIssuerGroup=cert-manager.io
#helm -n dev install kafka  -f kafka-values.yaml bitnami/kafka
kubectl apply -f grafana-ingress.yaml -n mon
helm repo add elastic https://helm.elastic.co
helm -n mon -f filebeat-inginx.yaml install filebeat-nginx elastic/filebeat
