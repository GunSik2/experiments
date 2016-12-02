
## Compatiblility
- RELEASE 'bosh-cloudstack-cpi-release 15'
  - bosh 260 
  - cloudstack 4.5 / 4.7 
  - xen 6.5 (Ikoula public cloud) 
  - stemcell 3263.10

## Configuration
- Micro-bosh 
```
name: bosh

releases:
- name: bosh
  url: https://bosh.io/d/github.com/cloudfoundry/bosh?v=260
  sha1: f8f086974d9769263078fb6cb7927655744dacbc
- name: bosh-cloudstack-cpi-release
  url: https://bosh.io/d/github.com/cloudfoundry-community/bosh-cloudstack-cpi-release?v=15
  sha1: ee408f6d4b0b94f28e5484b4290226560bb6e04f

resource_pools:
- name: vms
  network: private
  stemcell:
    url:  https://orange-candidate-cloudstack-xen-stemcell.s3.amazonaws.com/bosh-stemcell/cloudstack/bosh-stemcell-3263.10-cloudstack-xen-ubuntu-trusty-go_agent.tgz
    sha1: 16ca5adba391af2cd8d3ec2536e2d1604e34f2a6

...
```
- [bosh.yml template](https://github.com/cloudfoundry-community/bosh-cloudstack-cpi-release/blob/master/templates/bosh-init.yml)

## Running
- First run the bosh-cloudstack-cpi-core in standalone mode : you may need to create an application.yml
- Second run the bosh-cpi-release by running bosh-init with bosh.yml : you may config the cpi server of the first step 

## Reference
- [Bosh-cloudstack-cpi-release Git](https://github.com/cloudfoundry-community/bosh-cloudstack-cpi-release)
- [Bosh-cloudstack-cpi-release Release](http://bosh.io/releases/github.com/cloudfoundry-community/bosh-cloudstack-cpi-release?all=1)
- [Bosh-cloudstack-cpi-release Job configuration](http://bosh.io/jobs/cloudstack_cpi?source=github.com/cloudfoundry-community/bosh-cloudstack-cpi-release&version=15)
- [Bosh Release 260](http://bosh.io/releases/github.com/cloudfoundry/bosh?version=260)
- [CloudStack Documentation](http://docs.cloudstack.apache.org/en/latest/)
- [bosh-cloudstack-cpi-core](https://github.com/cloudfoundry-community/bosh-cloudstack-cpi-core)
