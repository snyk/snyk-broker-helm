
[![Snyk logo](https://snyk.io/style/asset/logo/snyk-print.svg)](https://snyk.io) 

# Helm Chart for Snyk Broker

This is a Helm Chart to deploy the [Snyk Broker](https://github.com/snyk/broker)

## Usage

Clone this repository and build the chart.

```
helm package /snyk-broker
```

Then run the following commands based on the repository type.

<b> Allowed values for </b> ```scmType```:

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
             --set bitbucketApi=<ENTER_BITBUCKET_API_URL> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
```

### Gitlab

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=gitlab \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set gitlab=<ENTER_GITLAB_URL> \
             --set gitlabToken=<ENTER_GITLAB_TOKEN> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
```

### Azure Repos

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=azure-repos \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set azureReposToken=<ENTER_REPO_TOKEN> \
             --set azureReposOrg=<ENTER_REPO_ORG> \
             --set azureReposHost<ENTER_REPO_HOST> \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
```

### Artifactory

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=artifactory \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set artifactoryUrl=<ENTER_ARTIFACTORY_URL> \
             -n snyk-broker --create-namespace
```

### Jira

```
helm install snyk-broker-chart snyk-broker=0.1.0.tgz \
             --set scmType=jira \
             --set brokerToken=<ENTER_BROKER_TOKEN> \
             --set jiraUsername=<ENTER_JIRA_USERNAME> \
             --set jiraPassword=<ENTER_JIRA_PASSWORD>  \
             --set jiraHostname<ENTER_JIRA_HOSTNAME>  \
             --set brokerClientUrl=<ENTER_BROKER_CLIENT_URL> \
             -n snyk-broker --create-namespace
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
| `service.port`                        | Front End Port for broker clien                                             | `8000`                                                                        |

