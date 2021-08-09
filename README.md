
[![Snyk logo](https://snyk.io/style/asset/logo/snyk-print.svg)](https://snyk.io) 

# Helm Chart for Snyk Broker

This is a Helm Chart to deploy the [Snyk Broker](https://github.com/snyk/broker)

## Usage

Clone this repository and navigate to the ```snyk-broker``` directory.

Then run the following commands based on the repository type.

<b> Allowed values for </b> ```scmType```:

Github.com: ```github-com``` <br>
Github Enterprise: ```github-enterprise```<br>
Bitbucket: ```bitbucket-server```<br>
Gitlab: ```gitlab```<br>
Azure Repos: ```azure-repos```<br>
Artifactory: ```artifactory```<br>
Jira: ```jira```<br>
Container Registry Agent: ```container-registry-agent```<br>

The following examples will create a namespace called ```snyk-broker```. To deploy into an existing namespace, adjust the ```-n``` parameter and delete the ```--create-namespace``` parameter.

### Github.com

```
helm install snyk-broker-chart . \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```
### Github Enterprise

```
helm install snyk-broker-chart . \
             --set scmType=github-enterprise \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set github=<ENTER_GHE_ADDRESS> \
             --set githubApi=<ENTER_GHE_API_ADDRESS> \
             --set githubGraphQl=<ENTER_GRAPHQL_ADDRESS> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```

### Bitbucket

```
helm install snyk-broker-chart . \
             --set scmType=bitbucket-server \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set bitbucketUsername=<ENTER_USERNAME> \
             --set bitbucketPassword=<ENTER_PASSWORD> \
             --set bitbucket=<ENTER_BITBUCKET_URL> \
             --set bitbucketApi=<ENTER_BITBUCKET_API_URL> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```

### Gitlab

<b>Note: for ```gitlab``` value do not include ```https://``` </b>

```
helm install snyk-broker-chart . \
             --set scmType=gitlab \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set gitlab=<ENTER_GITLAB_URL> \
             --set scmToken=<ENTER_GITLAB_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```

### Azure Repos

```
helm install snyk-broker-chart . \
             --set scmType=azure-repos \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set azureReposToken=<ENTER_REPO_TOKEN> \
             --set azureReposOrg=<ENTER_REPO_ORG> \
             --set azureReposHost<ENTER_REPO_HOST> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```

### Artifactory

```
helm install snyk-broker-chart . \
             --set scmType=artifactory \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set artifactoryUrl=<ENTER_ARTIFACTORY_URL> \
             -n snyk-broker --create-namespace
```

### Jira

```
helm install snyk-broker-chart . \
             --set scmType=jira \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set jiraUsername=<ENTER_JIRA_USERNAME> \
             --set jiraPassword=<ENTER_JIRA_PASSWORD>  \
             --set jiraHostname<ENTER_JIRA_HOSTNAME>  \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```
## Container Registry
Note: This chart will deploy two containers in a pod. While the documentation for the [Snyk Broker](https://github.com/snyk/broker) requires the parameter CR_AGENT_URL, it is not required in this case. You must also ensure that the brokerClientUrl value does NOT have a ```\``` 

Finally, you must include an ```accept.json``` file for this deployment.

```
helm install snyk-broker-chart . \
             --set scmType=container-registry-agent \
             --set brokerClientUrl=<ENTER_BROKER_URL> \
             --set crType=<ENTER_CR_TYPE>\
             --set crBase=<ENTER_CR_BASE_URL> \
             --set crUsername=<ENTER_CR_URSERNAME> \
             --set crPassword=<ENTER_CR_PASSWORD> \
             -n snyk-broker --create-namespace
```            
<b> Allowed values for </b> ```crType```:

```ArtifactoryCR```<br>
```HarborCR```<br>
```AzureCR```<br>
```GoogleCR```<br>
```DockerHub```<br>
```QuayCR```<br>
```nexus-cr```<br>
```github-cr```<br>

## Adding accept.json
To add a custom ```accept.json```, <b>you must copy the new accept.json to the /snyk-broker folder.</b><br><br> See example files [HERE](https://github.com/snyk/broker/tree/master/client-templates)

Here is an example command:

```
helm install snyk-broker-chart . \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             --set acceptJsonFile=accept.json \
             -n snyk-broker --create-namespace
```
## Ingress Options
There are two options available for ingress traffic. By default, the pods are not accessible from outside the cluster.

### Load Balancer
To enable a load balancer, add the ```--set service.type=LoadBalancer```

Example for Github:

```
helm install snyk-broker-chart . \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             --set service.type=LoadBalancer \
             -n snyk-broker --create-namespace
```
### Ingress Controller
This chart can be used with an existing ingress controller. Add the ```--set enableIngress=true``` parameter to enable the feature and ```--set ingressHostname=<ENTER_INGRESS_HOSTNAME>``` to configure the host name.

Example command:
```
helm install snyk-broker-chart . \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             --set enableIngress=true \
             --set ingressHostname=<ENTER_INGRESS_HOSTNAME>
             -n snyk-broker --create-namespace
```

## Secrets
API Tokens and or Passwords use Kubernetes Secrets. Existing secrets can be used, they just need to be created in the following formats.

### Broker Tokens
```
apiVersion: v1
kind: Secret
metadata:
  name: <ENTER_SCM_TYPE>-broker-token
  labels:
    app: <ENTER_SCM_TYPE>-broker-token
type: Opaque
data:
  <ENTER_SCM_TYPE>-broker-token-key: <BASE64_ENCODED_SECRET>
```

### SCM Token

```
apiVersion: v1
kind: Secret
metadata:
  name: <ENTER_SCM_TYPE>-token
type: Opaque
data:
  <ENTER_SCM_TYPE>-token-key: <BASE64_ENCODED_SECRET>
```

### Bitbucket Password

```
apiVersion: v1
kind: Secret
metadata:
  name: bitbucketpassword
type: Opaque
data:
  "bitbucketPassword": <BASE64_ENCODED_SECRET>
```

### Jira Password 

```
apiVersion: v1
kind: Secret
metadata:
  name: jirapassword
type: Opaque
data:
  "jiraPassword": <BASE64_ENCODED_SECRET>
```

### Container Registry Secret 

```
apiVersion: v1
kind: Secret
metadata:
  name: crpassword
type: Opaque
data:
  "crPassword": <BASE64_ENCODED_SECRET> 
 ``` 

## Service Accounts

To use an existing service account, add the following parameters to the install command:

```
--set serviceAccount.create=false \
--set serviceAccount.name=<ENTER_EXISTING_SERVICE_ACCOUNT> \
```

## Deploying Multiple Brokers In The Same Namespace

To deploy an additional broker into the same namespace as an existing broker, see the following example.

### Existing Service Account
```
helm install <ENTER_UNIQUE_CHART_NAME> . \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             --set serviceAccount.create=false \
             --set serviceAccount.name=<EXISTING_SERVICE_ACCOUNT> \
             -n <EXISTING_NAMESPACE>
```

### New Service Account 

```
helm install <ENTER_UNIQUE_CHART_NAME> . \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             --set serviceAccount.name=<NEW_SERVICE_ACCOUNT_TO_BE_CREATED> \
             -n <EXISTING_NAMESPACE>
```

## Configuration

| Parameter                             | Description                                                                 | Default value                                                                 |
| :-------------------------------------| :---------------------------------------------------------------------------| :---------------------------------------------------------------------------- |
| `brokerToken`                         | Snyk Broker Token                                                           | ` `                                                                           |
| `brokerClientUrl`                     | URL of Broker Client                                                        | ` `                                                                           |
| `scmType`                             | SCM Type - See above for allowed values                                     | `github-com`                                                                  |
| `scmToken`                            | API Token for SCM Provider (unless username/password require)               | ` `                                                                           |
| `github`                              | URL for Github Enterprise                                                   | ` `                                                                           |
| `githubApi`                           | URL for Github Enterprise API endpoint                                      | ` `                                                                           |
| `githubGraphQl`                       | URL for Github Enterprise GraphQL                                           | ` `                                                                           |
| `bitbucketUsername`                   | Bitbucket Username                                                          | ` `                                                                           |
| `bitbucketPassword`                   | Bitbucket Password                                                          | ` `                                                                           |
| `bitbucket`                           | Bitbucket URL                                                               | ` `                                                                           |
| `bitbucketApi`                        | Bitbucket API URL                                                           | ` `                                                                           |
| `gitlab`                              | URL for Gitlab                                                              | ` `                                                                           |
| `azureReposOrg`                       | Azure Repos Org                                                             | ` `                                                                           |
| `azureReposHost`                      | Azure Repos URL                                                             | ` `                                                                           |
| `artifactoryUrl`                      | Artifactory URL                                                             | ` `                                                                           |
| `jiraUsername`                        | Jira Username                                                               | ` `                                                                           |
| `jiraPassword`                        | Jira Password                                                               | ` `                                                                           |
| `jiraHostname`                        | Jira Hostname                                                               | ` `                                                                           |
| `logLevel`                            | Log Verbosity                                                               | `info`                                                                        |
| `logEnableBody`                       | Enable Log Body                                                             | `false`                                                                       |
| `image.repository`                    | Broker Image                                                                | `snyk/broker`                                                                 |
| `deployment.container.containerPort`  | Container Port (Back End)                                                   | `8080`                                                                        |
| `serviceAccount.name`                 | Name of service account to be created                                       | `snyk-broker`                                                                 |
| `service.port`                        | Front End Port for broker client                                            | `8000`                                                                        |
| `crImage`                             | Image Tag                                                                   | `latest`                                                                      |
