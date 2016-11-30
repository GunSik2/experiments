## Rexray
### Overview
- Supported Providers
  - EMC - ScaleIO, Isilon
  - VirtualBox - 	Virtual Media
  - Amazon EC2 - EBS, EFS
- Planned Providers
  - Ggoolge Compute Engine - disk
  - OpenStack - Cinder
  - EMC - XtremIO
- Client-Server 

### Handon
- Installation
```
curl -sSL https://dl.bintray.com/emccode/rexray/install | sh -
```

- Test : EBS volume
```
$ export REXRAY_SERVICE=ebs
$ export EBS_ACCESSKEY=access_key
$ export EBS_SECRETKEY=secret_key
$ rexray service start
Starting REX-Ray...SUCCESS!

  The REX-Ray daemon is now running at PID XX. To
  shutdown the daemon execute the following command:

    sudo /usr/bin/rexray stop

$ docker run -ti --volume-driver=rexray -v test:/test busybox
$ df /test
```

- Test: Postgres
```
$ docker volume create --driver=rexray --name=postgresql --opt=size=<sizeInGB>
$ docker run -d -e POSTGRES_PASSWORD=mysecretpassword --volume-driver=rexray \
    -v postgresql:/var/lib/postgresql/data postgres
```

### Docker External Access
- Override the default-docker module's endpoint address
```
sudo vi /etc/default/docker
DOCKER_OPTS='
-H tcp://0.0.0.0:7981
-H unix:///var/run/docker.sock
..
'

# vi /etc/docker/plugins/rexray.spec
tcp://192.168.56.20:7981
```



## Reference
- [Rexray github](https://github.com/codedellemc/rexray)
- [Rexray applicaitons](http://rexray.readthedocs.io/en/stable/user-guide/applications/)
- [Docker Storage Patterns for Persistence](https://kvaes.wordpress.com/2016/02/11/docker-storage-patterns-for-persistence/)
- [Configure and run Docker on various distributions](https://docs.docker.com/engine/admin/)
