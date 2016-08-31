## 환경 
  - Ubuntu 14.04

## Docker 설치
```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
vi /etc/apt/sources.list.d/docker.list
--
deb https://apt.dockerproject.org/repo ubuntu-trusty main
--
sudo apt-get update
apt-cache policy docker-engine
sudo apt-get install docker-engine
sudo service docker start
sudo docker run hello-world
```
## ngrinder controller 설치
- Controller
```
docker pull ngrinder/controller:3.4
docker run -d -v ~/ngrinder-controller:/opt/ngrinder-controller -p 80:80 -p 16001:16001 -p 12000-12009:12000-12009 ngrinder/controller:3.4
```
- 접속: http://<controller-ip>/ 
- 접속 계정: admin/admin

- Agent
```
docker pull ngrinder/agent:3.4
docker run -v ~/ngrinder-agent:/opt/ngrinder-agent -d ngrinder/agent:3.4 controller_ip:controller_web_port
```

## 참고문서
- https://docs.docker.com/engine/installation/linux/ubuntulinux/
- https://hub.docker.com/r/ngrinder/controller/
- https://github.com/naver/ngrinder/wiki/Installation-Guide
- https://github.com/naver/ngrinder/wiki/Quick-Start
