
[![Snyk logo](https://snyk.io/style/asset/logo/snyk-print.svg)](https://snyk.io) 

# Helm Chart for Snyk Broker

This is a Helm Chart to deploy the [Snyk Broker](https://github.com/snyk/broker)

## Usage

Clone this repository and build the chart.

```
helm package /snyk-broker
```

Then run the following commands based on the repository type.

<b> Allowed values for </b> ```scmType```:<br><br>

Github.com: ```github-com``` <br>
Github Enterprise: ```github-enterprise```<br>
Bitbucket: ```bitbucket-server```<br>
Gitlab: ```gitlab```<br>
Azure Repos: ```azure-repos```<br>
Artifactory: ```artifactory```<br>
Jira: ```jira```<br>


### Github.com

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
```
### Github Enterprise

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=github-enterprise \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set github=<ENTER_GHE_ADDRESS> \
             --set githubApi=<ENTER_GHE_API_ADDRESS> \
             --set githubGraphQl=<ENTER_GRAPHQL_ADDRESS> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
```

### Bitbucket

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=bitbucket-server \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set bitbucketUsername=<ENTER_USERNAME> \
             --set bitbucketPassword=<ENTER_PASSWORD> \
             --set bitbucket=<ENTER_BITBUCKET_URL> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
```
