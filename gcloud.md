## Google Cloud SDK Install
- Install Guilde: https://cloud.google.com/sdk/docs/quickstart-windows
- Installer download: https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe

## Cloud Repository 
- Adding the repository
```
cd [REPO_DIRECTORY]
git config credential.helper gcloud.cmd  // for windows
git remote add google https://source.developers.google.com/p/[PROJECT_ID]/
```
- Cloning a repository
```
gcloud init 
gcloud source repos clone default [LOCAL_DIRECTORY]
cd [LOCAL_DIRECTORY]
```
- Using the repository as a remote
```
git push google master
git pull google master
git log google/master
```

- Error resolving
```
$ git config --list --system
credential.helper=manager
$ git config --system --unset credential.helper
```

## Google App Engine
- check region/projects
```
$ gcloud app regions list
REGION           SUPPORTS STANDARD  SUPPORTS FLEXIBLE
asia-northeast1  YES                YES
europe-west      YES                NO
us-central       YES                YES
us-east1         YES                YES

$ gcloud projects list // project list
```
- app create
```
gcloud app create --project [PROJECT_ID] --region asia-northeast1
```
- app deploy
```
gcloud app deploy --project [PROJECT_ID]
```
- browse app
```
gcloud app browse
```
- static web site: https://cloud.google.com/appengine/docs/python/getting-started/hosting-a-static-website
