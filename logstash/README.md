#Logstash Setup for Local Deployment
Reuse the logstash chart in [helm/charts/stable/logstash](https://github.com/helm/charts/tree/master/stable/logstash)

## Run Command
helm install --name logstash stable/logstash -f values.yml
