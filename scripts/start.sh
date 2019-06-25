#!/usr/bin/env bash
echo '======================================================================================='
echo '    This script sets up a local deployment with fluentd/logstash/kibana    '
echo '    To Feed in data after the deployment is up
      use: kc cp evaluator-rs.log fluentd-xxx:/var/log/es/evaluator-rs.log to feed data    '
echo '======================================================================================='

echo '---- Ensure minikube is installed ----'
minikube version

echo '---- Ensure virtual is installed ----'
virtualbox --help

echo '---- Ensure helm is installed ----'
helm version

echo '---- Start minikue ----'
minikube start --memory 8192 --cpus 4 --disk-size 64g
echo '***** Sleep 5 minutes for minikube and vm to be ready *****'
sleep 300

echo '---- Init tiller (helm server running in kubernetes cluster) ----'
helm init
echo '***** Sleep 1 minute for tiller to finish deploying *****'
sleep 60

echo '---- Cone helm chart repo ----'
git clone git@github.com:wjche/helm-charts.git
cd helm-charts

echo '---- Deploy elasticsearch cluster in kubernetes ----'
helm install --name elasticsearch ./elasticsearch -f elasticsearch/examples/minikube/values.yaml --version 7.1.1
echo '***** Sleep 1 minute for elasticsearch to finish deploying *****'
sleep 60

echo '---- Deploy logstash in kubernetes ----'
helm install --name logstash stable/logstash -f logstash/values.yaml
echo '***** Sleep 1 minute for logstash to finish deploying *****'
sleep 60

echo '---- Deploy kibana in kubernetes ----'
helm install --name kibana ./kibana -f kibana/values.yaml
echo '***** Sleep 1 minute for kibana to finish deploying *****'
sleep 60

echo '---- Deploy fluentd in kubernetes ----'
helm install --name fluentd stable/fluentd -f fluentd/values.yaml
echo '***** Sleep 1 minute for fluentd to finish deploying *****'
sleep 60

echo '---- Open localhost:5601 for kibana ----'
kubectl port-forward deployment/kibana-kibana 5601
