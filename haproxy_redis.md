## haproxy 구성

### haproxy 설치
```
sudo add-apt-repository ppa:vbernat/haproxy-1.5 
sudo apt-get update 
sudo apt-get dist-upgrade -y
sudo apt-get install haproxy -y
sudo vi /etc/default/haproxy
ENABLED=1
```

### haproxy 설정
- redis_haproxy
```
global
    log 127.0.0.1 local0 notice
    user haproxy
    group haproxy

defaults
    log global
    retries 2
    timeout connect 3000
    timeout server 10m
    timeout client 10m

listen redis 0.0.0.0:6379
    balance source
    mode tcp
    option tcpka
    server redis_1 172.16.129.4:6379 check weight 1
    server redis_2 172.16.129.5:6379 check weight 1

frontend broker-in
    mode http
    bind :80
    option httpclose
    option forwardfor 
    reqadd X-Forwarded-Proto:\ http
    default_backend broker

frontend dashboard-in
    mode http
    bind :443 ssl crt /etc/haproxy/cert no-sslv3 ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES12$-CBC-SHA256:ECDHE-RSA-AES256-CBC-SHA384:ECDHE-RSA-AES128-CBC-SHA:ECDHE-RSA-AES256-CBC-SHA:AES128-SHA256:AES128-SHA
    option httplog
    option forwardfor
    reqadd X-Forwarded-Proto:\ https
    default_backend dashboard

backend broker
    mode http
    balance roundrobin
    server broker_1 172.16.129.6:80 check inter 1000

backend dashboard
    mode http
    balance roundrobin
    server broker_1 172.16.129.6:8080 check inter 1000    
```    
- certificate
```
cat /etc/haproxy/cert
-----BEGIN CERTIFICATE-----
MIIDLDCCAhQCCQCxGKC3IelrETANBgkqhkiG9w0BAQsFADBYMQswCQYDVQQGEwJB
...
-----END CERTIFICATE-----
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAtHXWtHKPlricUAmRwf0VfkSdZuU2aMEPcvf1/NdGca01foEO
...
-----END RSA PRIVATE KEY-----
```
### haproxy 시작
```
sudo service haproxy start
```

### Cert 생성
```
openssl genrsa -out paasxpert.key 2048
openssl req -new -key paasxpert.key -out paastastg.csr -subj "/C=AU/ST=Some-State/O=Crossent/CN=*.paasxpert.com"
openssl x509 -req -in paasxpert.csr -signkey paasxpert.key -out paasxpert.pem
cat paasxpert.pem paasxpert.key
```

