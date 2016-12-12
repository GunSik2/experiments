# S3
1. One of your users is trying to upload a 7.5GB file to S3 however they keep getting the following error message - "Your proposed upload exceeds the maximum allowed object size.". What is a possible solution for this?
   - Design your application to use the multi-part upload API for all objects (max put 5GB)
1. What is the minimum file size that I can store on S3? (1 Byte to 5T)


# EC2
1. Can I delete a snapshot of an EBS Volume that is used as the root device of a registered AMI?
  - No. you must deregister the AMI before being able to delete the root device. [More Info](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/deregister-ami.html)
  - When you creating a new AMIs from a running/stop instance, it will create a new snapshot and register it to AMI. So you need to deregister the AMI before deleting the snapshot.
  ![](http://codeomitted.com/wp-content/uploads/2016/04/Screen-Shot-2016-04-11-at-10.59.22-AM.png)
  
  
  
# Database
1. If you are using Amazon RDS Provisioned IOPS storage with MySQL and Oracle database engines what is the maximum size RDS volume you can have by default?
  - 6TB
1. By default, the maximum provisioned IOPS capacity on an Oracle and MySQL RDS instance (using provisioned IOPS) is 30,000 IOPS.
1. In RDS when using multiple availability zones, can you use the secondary database as an independent read node? (no)
1. When replicating data from your primary RDS instance to your secondary RDS instance, what is the charge? No Charge, Its free



# Etc
1. What are the four levels of AWS premium support? Basic, Developer, Business, Enterprise
1. What is the underlying Hypervisor for EC2? Xen

