
# Env
- ubuntu 14.04
- iaas: openstack mikata

# Juju installation
```
ssh-keygen -t rsa -b 2048
sudo add-apt-repository ppa:juju/stable
sudo apt-get update && sudo apt-get install juju-core
juju generate-config

vi ~/.juju/environments.yaml
# 설정 변경
    amazon:
        type: ec2
        region: ap-northeast-1
        access-key: <secret>
        secret-key: <secret>
```

# Juju test
```
juju bootstrap
juju deploy wordpress
juju deploy mysql
juju add-relation wordpress mysql
juju expose wordpress
juju status
juju destroy-environment 
```

# Juju frequently used commands
```
juju bootstrap -v
juju status
juju destory-environment
```


# Reference
- [Juju getting started](https://jujucharms.com/docs/1.24/getting-started)
