
[![Snyk logo](https://snyk.io/style/asset/logo/snyk-print.svg)](https://snyk.io) 

# Helm Chart for Snyk Broker

This is a Helm Chart to deploy the [Snyk Broker](https://github.com/snyk/broker)

## Usage

To add this chart, you can add the repo:
```helm repo add snyk-broker https://snyk.github.io/snyk-broker-helm/```

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
helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```
### Github Enterprise
<b>Note: for ```github```, ```githubApi``` and ```githubGraphQl``` values do not include ```https://``` </b>
```
helm install snyk-broker-chart snyk-broker/snyk-broker \
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
<b>Note: for ```bitbucket``` and ```bitbucketApi``` values do not include ```https://``` </b>

```
helm install snyk-broker-chart snyk-broker/snyk-broker \
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
helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=gitlab \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set gitlab=<ENTER_GITLAB_URL> \
             --set scmToken=<ENTER_GITLAB_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```

### Azure Repos
<b>Note: for ```azureReposHost```  value do not include ```https://``` </b>
```
helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=azure-repos \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set azureReposToken=<ENTER_REPO_TOKEN> \
             --set azureReposOrg=<ENTER_REPO_ORG> \
             --set azureReposHost<ENTER_REPO_HOST> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             -n snyk-broker --create-namespace
```

### Artifactory
<b>Note: for ```artifactoryUrl``` value do not include ```https://``` </b>
```
helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=artifactory \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set artifactoryUrl=<ENTER_ARTIFACTORY_URL> \
             -n snyk-broker --create-namespace
```

### Jira
<b>Note: for ```jiraHostname``` value do not include ```https://``` </b>
```
helm install snyk-broker-chart snyk-broker/snyk-broker \
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
helm install snyk-broker-chart snyk-broker/snyk-broker \
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
```ecr```<br>
```digitalocean-cr```

### Custom Container Registry Agent parameters
The following Container Registry types (crType) require specific parameters.

#### Elastic Container Registry (ecr)
* crRoleArn
* crRegion
* crExternalId

```
helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=container-registry-agent \
             --set brokerClientUrl=http://container-registry-agent-broker-service:8000 \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set crType=ecr \
             --set crRoleArn=<ENTER_CR_ROLE_ARN> \
             --set crRegion=<ENTER_CR_REGION> \
             --set crExternalId=<ENTER_CR_EXTERNAL_ID> \
             --set acceptJsonFile=accept.json \
             -n snyk-broker --create-namespace
```            

#### DigitalOcean Container Registry (digitalocean-cr)
* crToken

```
helm install snyk-broker-chart snyk-broker/snyk-broker \
             --set scmType=container-registry-agent \
             --set brokerClientUrl=http://container-registry-agent-broker-service:8000 \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set crType=digitalocean-cr \
             --set crBase=<ENTER_CR_BASE_URL> \
             --set crToken=<ENTER_CR_TOKEN> \
             --set acceptJsonFile=accept.json \
             -n snyk-broker --create-namespace
```            

## Snyk Code Agent
To deploy the Snyk Code Agent, you must set the ```enableCodeAgent``` flag to ```true```. See more information about the [Snyk Code Agent](https://docs.snyk.io/features/snyk-broker/snyk-broker-code-agent). Ensure you have the proper entries in the accept.json file. Grab the example file for the appropriate SCM [HERE](https://github.com/snyk/broker/tree/master/client-templates). Ensure you have the additional entries as specified by the Snyk Code Agent documentation.

Here is an example command for GitLab:

```
helm install snyk-broker-chart snyk-broker/snyk-broker \
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

## Adding custom accept.json
To add a custom ```accept.json``` file, include it in ```values.yaml```

See example ```accept.json``` files [HERE](https://github.com/snyk/broker/tree/master/client-templates)


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

You can then install:

```
helm install snyk-broker-gitub-com snyk-broker/snyk-broker -f values.yaml -n snyk-broker --create-namespace
```

## Ingress Options
There are two options available for ingress traffic. By default, the pods are not accessible from outside the cluster.

### Load Balancer
To enable a load balancer, add the ```--set service.<service-type>=LoadBalancer```. Allowed values are ```brokertype```, ```crType```, and ```caType```

Example for Github:

```
helm install snyk-broker-chart snyk-broker/snyk-broker \
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

## Deploying Multiple Brokers In The Same Namespace

To deploy an additional broker into the same namespace as an existing broker, see the following example.

### Existing Service Account
```
helm install <ENTER_UNIQUE_CHART_NAME> snyk-broker/snyk-broker \
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
helm install <ENTER_UNIQUE_CHART_NAME> snyk-broker/snyk-broker \
             --set scmType=github-com \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set scmToken=<ENTER_REPO_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL>:<ENTER_BROKER_CLIENT_PORT> \
             --set serviceAccount.name=<NEW_SERVICE_ACCOUNT_TO_BE_CREATED> \
             -n <EXISTING_NAMESPACE>
```
## Advanced Options

There is also the ability to set more advanced parameters. For troubleshooting SSL inspection issues, you can set the 
```tlsRejectUnauthorized``` parameter to ```disable```.<br><br>

```
--set tlsRejectUnauthorized=disable
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

### Multi-tenant Settings
#### Broker
To use this chart with different multi-tenant environments, set the ```brokerServerUrl``` to be one of the following URLs depending which environment you are using:

Europe: ```https://broker.eu.snyk.io```<br>
Australia: ```https://broker.au.snyk.io```<br>

```
--set brokerServerUrl=<BROKER_SERVER_URL>
```
#### Code Agent
If using Code Agent, this requires ```upstreamUrlCodeAgent``` value to be one of the following URLs depending which environment you are using:

Europe: ```https://deeproxy.eu.snyk.io```<br>
Australia: ```https://deeproxy.au.snyk.io```<br>
```
--set upstreamUrlCodeAgent=<UPSTREAM_URL>
```
