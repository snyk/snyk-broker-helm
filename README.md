
[![Snyk logo](https://snyk.io/style/asset/logo/snyk-print.svg)](https://snyk.io) 

# Helm Chart for Snyk Broker

This is a Helm Chart to deploy the [Snyk Broker](https://github.com/snyk/broker)

## Usage

To add this chart, you can add the repo:
```helm repo add snyk-broker https://snyk.github.io/snyk-broker-helm/```

In which case instead of ```helm install snyk-broker-chart .``` you would instead use ```helm install snyk-broker-chart snyk-broker``` for all the commands below. 

Alternatively, clone this repository and navigate to the ```/charts/snyk-broker``` directory.

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
## Container Registry Agent
 While the documentation for the [Snyk Broker](https://github.com/snyk/broker) requires the parameter ```CR_AGENT_URL```, it is not required in this case. 

Finally, you must include an ```accept.json``` file for this deployment. <b>You must copy the new accept.json to the /snyk-broker folder</b>

```
helm install snyk-broker-chart . \
             --set scmType=container-registry-agent \
             --set brokerClientUrl=http://container-registry-agent-broker-service:8000 \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set crType=<ENTER_CR_TYPE> \
             --set crBase=<ENTER_CR_BASE_URL> \
             --set crUsername=<ENTER_CR_URSERNAME> \
             --set crPassword=<ENTER_CR_PASSWORD> \
             --set acceptJsonFile=accept.json \
             -n snyk-broker --create-namespace
```            
<b> Allowed values for </b> ```crType```:

```artifactory-cr```<br>
```harbor-cr```<br>
```acr```<br>
```gcr```<br>
```docker-hub```<br>
```quay-cr```<br>
```nexus-cr```<br>
```github-cr```<br>

## Snyk Code Agent
To deploy the Snyk Code Agent, you must set the ```enableCodeAgent``` flag to ```true```. See more information about the [Snyk Code Agent](https://support.snyk.io/hc/en-us/articles/4404137655569-Snyk-Code-local-git-support). Ensure you have the proper entries in the accept.json file. Grab the example file for the appropriate SCM [HERE](https://github.com/snyk/broker/tree/master/client-templates). Ensure you have the additional entries as specified by the Snyk Code Agent documentation.

Here is an example command for GitLab:

```
helm install snyk-broker-chart . \
             --set scmType=gitlab  \
             --set brokerToken=<ENTER_BROKER_TOKEN> \ 
             --set scmToken=<ENTER_SCM_TOKEN> \
             --set gitlab=<ENTER_GITLAB_URL>  \
            --set acceptJsonFile=accept.json \
            --set brokerClientUrl=http://<BROKER_CLIENT_URL> \ 
            --set enableCodeAgent=true \ 
            --set snykToken=<ENTER_SNYK_TOKEN> \
            -n snyk-broker --create-namespace
```
<b>Note: The ```brokerClientUrl``` is going to be the address of the Broker Container. The default port for the broker container is ```8000```. See the values file for more information. Also, the accept.json must be in the same directory as the helm chart</b>

## Adding accept.json

To add a custom ```accept.json```, <b>you must copy the new accept.json to the /snyk-broker folder</b> <br><br>See example files [HERE](https://github.com/snyk/broker/tree/master/client-templates)

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

Alternatively, if you are using the built chart, you can run the command like so:
```
helm install snyk-broker-gitub-com snyk-broker/snyk-broker -f values.yaml -n snyk-broker --create-namespace
```

The ```values.yaml``` file should be structured like this:
```
scmType: github-com
brokerToken: <ENTER_BROKER_TOKEN>
scmToken: <ENTER_REPO_TOKEN>
acceptJson: |-
  {
    "public": [
      {
        "//": "used for pushing up webhooks from github",
        "method": "POST",
        "path": "/webhook/github",
        "valid": [
          {
            "//": "accept all pull request state changes (these don't have files in them)",
            "path": "pull_request.state",
            "value": "open"
          },
          {
            "path": "commits.*.added.*",
            "value": "package.json"
          },
  ...
    ]
  }
```  
## Ingress Options
There are two options available for ingress traffic. By default, the pods are not accessible from outside the cluster.

### Load Balancer
To enable a load balancer, add the ```--set service.<service-type>=LoadBalancer```. Allowed values are ```brokertype```, ```crType```, and ```caType```

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


## Service Accounts

To use an existing service account, add the following parameters to the install command:

```
--set serviceAccount.create=false \
--set serviceAccount.name=<ENTER_EXISTING_SERVICE_ACCOUNT> \
```

If you do not - or can not, due to permissions, etc - use service accounts, add the following parameters to the install command:

```
--set serviceAccount.enabled=false \
--set serviceAccount.create=false \
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
## Advanced Options

There is also the ability to set more advanced parameters. For troubleshooting SSL inspection issues, you can set the 
```tlsRejectUnauthorized``` parameter to ```"0"```.<br><br>

```
--set tlsRejectUnauthorized="0"
```

To provide your own certificate (signed by your own CA) - you can pass the file name (<b>it needs to reside within the helm chart directory</b>) to the ```caCert``` parameter. <br><br>

```
--set caCert=<CERT_NAME)>
```

If you would like your broker to run as an HTTPS server, you can pass the files (<b>they need to reside within the helm chart directory</b>) to the ```httpsCert``` and ```httpsKey``` paramters<br><br>

```
--set httpsCert=<CERT_NAME> --set httpsKey=<CERT_KEY>
```

### Proxy Settings
To use this chart behind a proxy, set the ```httpProxy``` and ```httpsProxy``` values.

```
--set httpsProxy=<PROXY_URL>
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
| `deployment.container.containerPort`  | Container Port (Back End)                                                   | `8000`                                                                        |
| `serviceAccount.enabled`              | Whether to use service accounts in deployment templates                     | `true`                                                                        |
| `serviceAccount.create`               | Whether Helm should create a new service account                            | `true`                                                                        |
| `serviceAccount.name`                 | Name of service account to be created                                       | `snyk-broker`                                                                 |
| `service.port`                        | Front End Port for broker client                                            | `8000`                                                                        |
| `crImage`                             | Image Tag                                                                   | `latest`                                                                      |
