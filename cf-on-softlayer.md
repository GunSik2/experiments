## Env
- [softlayer stemcell 3312.9](https://www.bosh.io/stemcells/bosh-softlayer-xen-ubuntu-trusty-go_agent)
- [softlayer cpi 3.0.1](https://bosh.io/releases/github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release?all=1)

## Bosh-init
- [softlayer deployment guide - bosh site](https://bosh.io/docs/init-softlayer.html)
- [softlayer deployment guide - git site](https://github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release/blob/master/docs/bosh-init-usage.md)
- [softlayer cpi config](https://bosh.io/docs/softlayer-cpi.html)
- softlayer cpi config [sample1](https://github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release/blob/b53babfca237a133ba866b5feb79bb8f82faa1c8/docs/sl-cloud-config.yml) [sample2](https://github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release/blob/b53babfca237a133ba866b5feb79bb8f82faa1c8/docs/mimimal-softlayer.yml)
- [softlayer cpi spec](https://github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release/blob/master/jobs/softlayer_cpi/spec)
- [softlayer cpi slack channel](https://cloudfoundry.slack.com/archives/bosh-softlayer-cpi)

## CF
- [softlayer cf yaml](https://github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release/blob/master/docs/mimimal-softlayer.yml)
- [softlayer cf guide](https://github.com/cloudfoundry-incubator/bosh-softlayer-cpi-release/blob/master/docs/minimalistic_cf_deployment.md)

## CLI
- Installation
```
# pip install softlayer
```
- Config
```
# slcli setup
```
- Use: [cli guide](http://softlayer-python.readthedocs.io/en/latest/cli.html)
```
$ slcli vs
$ slcli vs list
```

## Tips
- You need to run bosh-init deploy command in root user

## Consideration
- which type of subnet will you use, additional_primary or secondary_on_vlan? 
  - If you use primary, you use the static ip restricted to a vm. 
    (Primary IP는 자원 생성 시 해당 자원에 할당되는 IP 입니다. Primary IP는 고정IP 이며 자원이 생성시 할당되어 자원이 삭제될 때까지 유지됩니다.)
  - If you use secondary, you can move the ip to other vm positioned in other pods. (??)  
- The outbound traffic of the VMs in private vlan is not supported.
  - Vyatta Network Gateway Appliance is requred in production
  - [Ubuntu 14.04 as a Gateway in PoC/Dev](http://askubuntu.com/questions/590920/ubuntu-14-04-as-a-gateway-router-and-a-firewall): This option is not avialibe. The vlans are all different and it can't set other vlan as gateway.
- VLAN 내 네트워크 및 리소스는 이중화 되는가?
- VLAN 내 복수의 Subnet 구성할 것인가 / 복수 VLAN 내 단일 Subnet 으로 구성할 것인가


## Reference
- [cf v238 release notes](https://bosh.io/releases/github.com/cloudfoundry/cf-release?version=238)
