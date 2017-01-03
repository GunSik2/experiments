


```


##############################
# Service Broker
##############################
# Create Service Broker
cf create-service-broker mysql-service-broker admin admin  http://10.10.32.13:80
cf service-brokers
cf update-service-broker mysql-service-broker admin admin  http://10.10.32.13:80


cf service-access
cf enable-service-access rdsmysql
cf service-access


# Asynchronous Provisioning

cf marketplace
cf marketplace -s rdsmysql
cf create-service rdsmysql 5.6-small myrds
watch -n 10 "cf service myrds"
cf service myrds



# Arbitary Parameters

cf bind-service spring-music myrds -c '{"dbname":"musicdb"}'
cf env spring-music


# Service keys

cf create-service-key myrds myrdskey
cf service-key myrds myrdskey

cf create-service-key myrds musickey -c '{"dbname":"musicdb"}'
cf service-key myrds musickey

cf service-keys myrds


# Updating Service Plans
cf update-service myrds -p 5.6-large -c '{"apply_immediately":true}'
watch -n 10 "cf service myrds"


# DB Access App Deploy

git clone https://github.com/cloudfoundry-samples/spring-music
cd spring-music
./gradlew assemble
cf push
cf bind-service spring-music myrds
cf restart


###############
# UAAC
# https://github.com/cloudfoundry/uaa/blob/master/docs/UAA-Security.md
###############

uaac token client get admin -s secret

uaac users --attributes emails

uaac token decode

uaac contexts 		#password.write 권한 확인: 비밀번호 변경 권한에 해당)	

uaac -t password set test -p test1 	# (사용자 임시 비밀번호 발급)

uaac clients		#portal granttype으로 client_credentials password 를 가져야 함


uaac token client get portal
uaac token decode

uaac token owner get portal cgshome@gmail.com
uaac token decode

uaac token refresh 

uaac member add cloud_controller.admin cgshome@gmail.com
uaac member delete cloud_controller.admin cgshome@gmail.com

uaac client update admin --authorities "EXISTING-PERMISSIONS password.write"


###############
# Api query
###############

curl "http://router_user:password@10.178.80.130:8080/routes" | jq "."

```
