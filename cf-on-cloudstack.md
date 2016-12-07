
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
- [bosh.yml spec](https://github.com/cloudfoundry-community/bosh-cloudstack-cpi-release/blob/0c91c676bd0c39812e508756c68d312e9f6be263/jobs/cloudstack_cpi/spec)

## Architecture
![detailed diagram sequence](https://camo.githubusercontent.com/da0d92e999ade366f52601e498463ca75d65a301/687474703a2f2f706c616e74756d6c2e636f6d3a38302f706c616e74756d6c2f706e672f5a4c4a31526a696d333372464e71356172734756713230336a68474f5964526571364d78316842347336666949503161395f74784b4e416f6e38684a7a635a6f614e6e79563739587a5a32766c4e2d2d4d77775564595669612d4b6b41413469726d36615359593253476f72584342694d4837316f725f74345f5a796743656756417a5237394f38676f75325173345343653370533635796a4e504f41585f53517652524f493576626d727a564666702d746c72525663475348497251514b464e366f3779537750446331365f555f4677796f78506c59543646384954565a56576f714d75304373306b695135576a73723054634e2d45555330463238472d754665394f5a465239394338756561794868352d53474259746e5943476e6a513437653145326e456d4c6e33543656494b466b7a4f584d33586e7a7467307072744e304e4f6335444663694262517a672d51715738342d58657442776647445643487650747739435a436a47755a6e754a487442496c5f4e655066383746676d4f2d3859414465576f3155344f6436554937386e31733539726346683265557947726e3334456a436668756f3649394d426542675534774671534e6d6f324f3578534e666a62305050324a69626c7632645630424534643345706567365633325377346f707252594b66397846675f467a674f535f4576374936704335505161794c59536266564252597076664d78676271486a4c6a67496a6e68307052586c76717645573567434c5a4d6466417450444a75547147626a585775784e515375796b535159797a3663775056596a737951396d396f76726d61486d6e7079656b66736d5270304a563030793667415f737076354c786a4c5236364d63426365394e6f5647446e79574342414376644b6b4f66593439666d467a34764c74527471573943355a3234674e4e727779714879754c33664c545852365f573430)

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
- [bosh-cloudstack-cpi-core-docker](https://hub.docker.com/r/orangecloudfoundry/bosh-cloudstack-cpi-core/~/dockerfile/)
- [CloudStack API](https://cloudstack.apache.org/api/apidocs-4.8/TOC_User.html)
- [How to Add BOSH Support to a Custom Cloud](https://blog.altoros.com/how-to-add-bosh-support-to-a-custom-cloud-part-2-external-bosh-cpis.html)
