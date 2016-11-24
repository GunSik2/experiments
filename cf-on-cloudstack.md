
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
- name: bosh-cloudstack-cpi
  url: https://bosh.io/d/github.com/cloudfoundry-community/bosh-cloudstack-cpi-release?v=15
  sha1: ee408f6d4b0b94f28e5484b4290226560bb6e04f

resource_pools:
- name: vms
  network: private
  stemcell:
    url:  https://orange-candidate-cloudstack-xen-stemcell.s3.amazonaws.com/bosh-stemcell/cloudstack/bosh-stemcell-3262.3-cloudstack-xen-ubuntu-trusty-go_agent.tgz
    sha1: cf6f6925d133d0b579d154694025c027bc64ef88

...

jobs:
- name: bosh_api
  templates:
  - {name: nats, release: bosh}
  - {name: postgres, release: bosh}
  - {name: blobstore, release: bosh}
  - {name: director, release: bosh}
  - {name: health_monitor, release: bosh}
  - {name: powerdns, release: bosh}
  # - {name: registry, release: bosh}   #<-- registry. commented, cpi brings it own registry  
  - {name: cloudstack_cpi, release: bosh-cloudstack-cpi} # <-- add the external CPI
```

## Reference
- [Bosh-cloudstack-cpi-release Git](https://github.com/cloudfoundry-community/bosh-cloudstack-cpi-release)
- [Bosh-cloudstack-cpi-release Release]http://bosh.io/releases/github.com/cloudfoundry-community/bosh-cloudstack-cpi-release?all=1)
- [Bosh-cloudstack-cpi-release Job configuration](http://bosh.io/jobs/cloudstack_cpi?source=github.com/cloudfoundry-community/bosh-cloudstack-cpi-release&version=15)
- [Bosh Release 260](http://bosh.io/releases/github.com/cloudfoundry/bosh?version=260)
