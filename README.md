
[![Snyk logo](https://snyk.io/style/asset/logo/snyk-print.svg)](https://snyk.io) 

# Helm Chart for Snyk Broker

This is a Helm Chart to deploy the [Snyk Broker](https://github.com/snyk/broker)

## Usage

Clone this repository and build the chart.

```
helm package /snyk-broker
```

Then run the following commands based on the repository type.

### Github.com

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             -n snyk-broker --create-namespace
```
