## Quick Start

- 2G 이상 메모리
- sysctl -w vm.max_map_count=262144
```
sudo docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk sebp/elk

sudo docker exec -it <container-name> /bin/bash
/opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { hosts => ["localhost"] } }'
```

## Another method
docker network create --driver overlay logging

sysctl -w vm.max_map_count=262144
sysctl -p
docker service create --network logging --name elasticsearch -e ES_JAVA_OPTS="-Xmx10g -Xms10g" elasticsearch

docker service create --network logging --name kibana --publish 5601:5601 -e ELASTICSEARCH_URL=http://elasticsearch:9200 kibana

vi logstash.conf
input {
  # Listens on 514/udp and 514/tcp by default; change that to non-privileged port
  syslog { port => 51415 }
  # Default port is 12201/udp
  gelf { }
  # This generates one test event per minute.
  # It is great for debugging, but you might
  # want to remove it in production.
  heartbeat { }
}
# The following filter is a hack!
# The "de_dot" filter would be better, but it
# is not pre-installed with logstash by default.
filter {
  ruby {
    code => "
      event.to_hash.keys.each { |k| event[ k.gsub('.','_') ] = event.remove(k) if k.include?'.' }
    "
  }
}
output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
  }
  # This will output every message on stdout.
  # It is great when testing your setup, but in
  # production, it will probably cause problems;
  # either by filling up your disks, or worse,
  # by creating logging loops! BEWARE!
  stdout {
    codec => rubydebug
  }
}



docker service create --network logging --name logstash -p 12201:12201/udp logstash -e "$(cat logstash.conf)"


docker logs --follow [container id]


docker run --log-driver gelf --log-opt gelf-address=udp://127.0.0.1:12201 --rm busybox echo hello



## Reference
- https://elk-docker.readthedocs.io/
- https://lostechies.com/gabrielschenker/2016/10/05/docker-and-swarm-mode-part-3/
