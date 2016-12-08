## Resources
 
- AWS Cloud Computing Whitepapers
  - http://aws.amazon.com/whitepapers 
  - [Overview of Amazon Web Services](https://d0.awsstatic.com/whitepapers/aws-overview.pdf)
  - [Overview of Security Processes](https://d0.awsstatic.com/whitepapers/Security/AWS_Security_Whitepaper.pdf) 
  - [AWS Risk and Compliance](https://d0.awsstatic.com/whitepapers/compliance/AWS_Risk_and_Compliance_Whitepaper.pdf) 
  - Storage Options in the Cloud 
  - [AWS Storage Services Overview](https://d0.awsstatic.com/whitepapers/Storage/AWS%20Storage%20Services%20Whitepaper-v9.pdf)
  - [Architecting for the Cloud: AWS Best Practices](https://d0.awsstatic.com/whitepapers/AWS_Cloud_Best_Practices.pdf) 
- Use of the AWS Architecture Center website
  - http://aws.amazon.com/architecture

## IAM
- Components
  - Users
  - Groups
  - Roles
  - Policy Documents
  ```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "NotAction": "iam:*",
      "Resource": "*"
    }
  ]
}
  ```
- Properties
  - universal (all region)
  - default root account 
  - new users have no permissions when created
  - new users assigned Access Key Id & Secret Access Keys for CLI
  - setup multifactor authentication on root account

  
## S3
- object storage
  - one file can be from 1 byte to 5 tb, unlimited storage
    (upload size - PUT : 5G, Multipart: 5 TB)
  - universal namespace, unique globally
  - read after writer consistency for put of new file
  - storage classess/tiers: S3, S3-IA, S3-RRS(Reduced Redundancy Stroage)
  - Glacier
  - versioning + lifecycle rule + MFA delete capability + cross region replication
- lifecycle management
  - transition from S3 to S3-IA : 128Kb and 30 days after the creation date
  - archive to Glacier : 30 days after S3-IA
  - permanently delete
- CloudFront
  - edge location - separate to AWS region/AZ
  - origin : S3, Ec2, ELB, Route53
  - distribution : Web distribution / RTMP (media streaming)
  - read & write 
- Security
  - new buckets are PRIVATE
  - access control using bucket policies & access control lists
  - support logs
- Encryption
  - It transit: SSL/TLS
  - S3 Managed Keys - SSE-S3, SSE-KMS, SSE-C (Customer Provided Keys)
- Gateway
  - Gateway Stored Volumes
  - Gateway Cached Volumes
  - Gateway VTL(Virtual Tape Library)
- Import/Export
  - Import/Export Disk: Import to EBS/S3/Glacier, Export from S3
  - Import/Export Snowball: Import/Export to S3  

## White Papers
  - [AWS_Security](https://d0.awsstatic.com/whitepapers/Security/AWS_Security_Whitepaper.pdf)
  - [AWS_Risk_and_Compliance](https://d0.awsstatic.com/whitepapers/compliance/AWS_Risk_and_Compliance_Whitepaper.pdf)
  - [Storage Options in the AWS Cloud](https://d0.awsstatic.com/whitepapers/Storage/aws-storage-options.pdf)
  - [AWS_Cloud_Best_Practices](http://media.amazonwebservices.com/AWS_Cloud_Best_Practices.pdf)  
  - [AWS_Well-Architected_Framework](http://d0.awsstatic.com/whitepapers/architecture/AWS_Well-Architected_Framework.pdf)
