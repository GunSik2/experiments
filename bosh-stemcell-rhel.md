
Stemcell tarballs are currently specific to an IaaS-OS/CPI because they may:
- include custom Agent configuration (e.g. [OpenStack’s Agent configuration](https://github.com/cloudfoundry/bosh/blob/ede389a2e112e1b4f2dbc4495c08977da4439483/stemcell_builder/stages/bosh_openstack_agent_settings/apply.sh#L12-L41))
- include custom OS packages/configuration (e.g. [OpenStack’s OS customizations](https://github.com/cloudfoundry/bosh/blob/cdd7c7b333d076aa96c648825b1e9ba4ba7a22ba/bosh-stemcell/lib/bosh/stemcell/stage_collection.rb#L93-L94))
- be packaged into a custom image format (qcow, vmdk, etc.)


# Reference
- https://bosh.io/docs/build-stemcell.html
- 
