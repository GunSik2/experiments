## docker-boshrelease

## Deployment
- bosh release upload
```
git clone https://github.com/cf-platform-eng/docker-boshrelease.git
cd docker-boshrelease

bosh upload release releases/docker/docker-28.0.2.yml
```
- configure
```
vi samples/docker-swarm-broker-openstack.yml
# config following items
deployment_name
director_uuid
elastic_ip
root_domain

properties.nats.user
properties.nats.password
properties.nats.machines

properties.cf.admin_username
properties.cf.admin_password

properties.broker.username
properties.broker.password
```
- deploy
```
bosh deployment samples/docker-broker-aws-deploy.yml
bosh deploy
```
- enable broker
  - BROKER_NAME = properties.broker.name
  - BROKER_USER = properties.broker.username
  - BROKER_PASS = properties.broker.password
  - BROKER_HOST = properties.broker.host
```
cf create-service-broker BROKER_NAME BROKER_USER BROKER_PASS https://BROKER_HOST

sample)
cf create-service-broker cf-containers-broker containers containers http://10.104.2.10
```
- enable service
```
# enable all services
cf enable-service-access SERVICE

# enalbe specific services
cf enable-service-access SERVICE -p PLAN -o ORG
```
- create service instance
```
cf create-service SERVICE PLAN SERVICE_INSTANCE_NAME
```
- deploy app & bind it
```
cf bind-service APP_INSTAANCE_NAME SERVICE_INSTANCE_NAME
```


## Reference
- [Managing Stateful Docker Containers with Cloud Foundry BOSH](https://blog.pivotal.io/pivotal-cloud-foundry/products/managing-stateful-docker-containers-with-cloud-foundry-bosh)
- [Docker Service Broker for Cloud Foundry](https://blog.pivotal.io/pivotal-cloud-foundry/products/docker-service-broker-for-cloud-foundry)
- [cloud.gov Deploying the Docker broker](https://cloud.gov/docs/ops/deploying-the-docker-broker/)
- [Git: Containers Service Broker for Cloud Foundry](https://github.com/cloudfoundry-community/cf-containers-broker)
- [Git: Bosh release for Docker](https://github.com/cloudfoundry-community/docker-boshrelease)
