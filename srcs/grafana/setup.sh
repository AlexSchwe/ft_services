envsubst '${DB} ${DB_USER} ${DB_PASS}' < /tmp/datasource.yaml > /grafana-6.7.1/conf/provisioning/datasources/datasource.yaml
cp /tmp/dashboards/sample.yaml /grafana-6.7.1/conf/provisioning/dashboards/
cp /tmp/dashboards/*.json /grafana-6.7.1/conf/provisioning/dashboards/mine
cd /grafana-6.7.1/bin/ && ./grafana-server web
