Bosh OpenStack API Call List 
=============================


Table of Contents
--------------
* [compute (nova)](#compute-nova)
* [identity (keystone)](#identity-keystone)
* [identityv3 (keystonev3)](#identityv3-keystonev3)
* [image (glance)](#image-glance)
* [network (neutron)](#network-neutron)
* [volumev2 (cinderv2)](#volumev2-cinderv2)
      
compute (nova)
--------------

```
DELETE /v2/<tenant_id>/servers/<resource_id>
DELETE /v2/<tenant_id>/servers/<resource_id>/os-volume_attachments/<resource_id>
GET /v2/<tenant_id>//servers/<resource_id>/os-volume_attachments
GET /v2/<tenant_id>/flavors/detail.json
GET /v2/<tenant_id>/os-keypairs.json
GET /v2/<tenant_id>/os-security-groups.json
GET /v2/<tenant_id>/servers/<resource_id>.json
GET /v2/<tenant_id>/servers/<resource_id>/metadata/registry_key
POST /v2/<tenant_id>/servers.json
POST /v2/<tenant_id>/servers/<resource_id>/metadata.json
POST /v2/<tenant_id>/servers/<resource_id>/os-volume_attachments 
PUT /v2/<tenant_id>/servers/<resource_id>.json 
```

identity (keystone)
--------------------

```
POST /v2.0/tokens
```

identityv3 (keystonev3)
------------------------

```
POST /v3/auth/tokens
```

image (glance)
--------------

```
DELETE /v1/images/<resource_id>
DELETE /v2/images/<resource_id>
GET /
GET /v1/images/detail
GET /v2/images/<resource_id>
GET /v2/images/non-existing-id
POST /v1/images
POST /v2/images
PUT /v2/images/<resource_id>/file
```

network (neutron)
-----------------

```
DELETE /v2.0/ports/<resource_id>
GET /
GET /v2.0/floatingips?floating_ip_address=<floating_ip_address>
GET /v2.0/networks/<resource_id>
GET /v2.0/ports/<resource_id>
GET /v2.0/ports?device_id=<device_id>
GET /v2.0/ports?device_id=<device_id>&network_id=<network_id>
GET /v2.0/security-groups
POST /v2.0/ports 
PUT /v2.0/floatingips/<resource_id> 
```

volumev2 (cinderv2)
-------------------
```
DELETE /v2/<tenant_id>/snapshots/<resource_id>
DELETE /v2/<tenant_id>/volumes/<resource_id>
GET /v2/<tenant_id>/snapshots/<resource_id>
GET /v2/<tenant_id>/volumes/<resource_id>
POST /v2/<tenant_id>/snapshots
POST /v2/<tenant_id>/volumes
```

