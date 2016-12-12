


## Security
### Requirements
- 데이터 보호
  - 저장된 데이터를 어떤 방식으로 암호화하고 보호합니까?
  - 전송 중인 데이터를 어떤 방식으로 암호화하고 보호하고 있습니까?
- 권한 관리
  - AWS 루트 계정 자격 증명에 대한 액세스 및 사용을 어떻게 보호하고 있습니까?
  - AWS Management Console 및 API에 대한 액세스를 제어하기 위해 시스템 사용자의 역할 및 책임을 어떻게 정의하고 있습니까?
  - 애플리케이션, 스크립트 또는 타사의 도구나 서비스를 이용하는 등 AWS 리소스에 대한 자동 액세스를 어떤 식으로 제한하고 있습니까?
  - 키와 자격 증명을 어떻게 관리하고 있습니까?
- 인프라 보호
  - 네트워크 및 호스트 수준 경계 보호를 어떻게 적용하고 있습니까?
  - AWS 서비스 수준 보호를 어떻게 적용하고 있습니까?
  - Amazon EC2 인스턴스에서 운영 체제의 무결성을 어떻게 보호하고 있습니까?
- 탐지 제어
  - AWS 로그를 어떻게 캡처하고 분석하고 있습니까?
  
### Solutions
- 데이터 보호: Elastic Load Balancing, Amazon Elastic Block Store(EBS), Amazon Simple Storage Service(S3) 및 Amazon Relational Database Service(RDS) 등의 서비스에는 암호화 기능이 포함되어 있으므로 전송 및 저장 상태의 데이터를 보호해 줍니다. AWS Key Management Service(KMS)를 이용하면 암호화에 사용되는 키를 더 쉽게 만들고 제어할 수 있습니다.
- 권한 관리: IAM은 AWS 서비스와 리소스에 대한 액세스를 안전하게 제어할 수 있도록 합니다. Multi-Factor Authentication(MFA)은 사용자 이름과 암호 외에 보호 계층을 한 단계 더 추가해 줍니다.
- 인프라 보호: Amazon Virtual Private Cloud(VPC)를 통해 AWS 클라우드의 격리된 프라이빗 영역을 프로비저닝하고, 가상 네트워크에서 AWS 리소스를 실행할 수 있습니다.
- 탐지 제어: AWS CloudTrail은 AWS API 호출을 기록하고, AWS Config는 AWS 리소스 및 구성에 대한 자세한 재고 정보를 제공하며, Amazon CloudWatch는 AWS 리소스에 대한 모니터링 서비스입니다.


## Reliability 안정성 기반
### Requirements
- 기반
  - 계정에 대한 AWS 서비스 제한을 어떻게 관리하고 있습니까? 
  - AWS에서 네트워크 토폴로지를 어떻게 계획하고 있습니까? 
  - 기술적 문제를 해결하기 위한 에스컬레이션 경로가 있습니까?
- 변경 관리
  - 시스템이 수요 변화에 어떻게 대처하고 있습니까? 
  - AWS 리소스를 어떻게 모니터링하고 있습니까? 
  - 변경 관리를 어떻게 수행하고 있습니까?
- 장애 관리
  - 데이터를 어떻게 백업하고 있습니까? 
  - 구성 요소 장애 시 시스템에서 어떻게 대처합니까? 
  - 복구를 어떻게 계획하고 있습니까?
  
### Solutions
- 기반: AWS Identity and Access Management(IAM)를 통해 AWS 서비스와 리소스에 대한 액세스를 안전하게 제어할 수 있습니다. Amazon VPC를 통해 AWS 클라우드의 격리된 프라이빗 영역을 프로비저닝하고, 가상 네트워크에서 AWS 리소스를 실행할 수 있습니다.
- 변경 관리: AWS CloudTrail은 계정에 대한 AWS API 호출을 기록하고 로그 파일을 감사할 수 있도록 사용자에게 전달합니다. AWS Config는 AWS 리소스 및 구성에 대한 자세한 목록 정보를 제공하고, 구성 변경 사항을 지속적으로 기록합니다.
- 장애 관리: AWS CloudFormation으로 AWS 리소스의 템플릿을 만든 다음, 예측 가능한 방식으로 순서에 따라 이를 프로비저닝할 수 있습니다.


## Performance Efficiency 성능 효율성 기반
### Requirements
### Solutions

## Cost Optimization
### Requirements
### Solutions

## Operational Excellence
### Requirements
### Solutions
