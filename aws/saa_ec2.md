
Instances 
- On Demand
- Spot
- Reserved
- Dedicated host

EC2 Instance Types
- T2 : General Purpose, Lowest Cost
- M4/M3 : General Purpose
- C4/C3 : Compute Optimized
- R3 : Memory Optimized
- G2 : GPU Optimized
- I2 : High Speed Storage
- D2 : Dense Storage

EBS
- GP2 (General Purpose SSD) : up to 10,000 IOPS
- IO1 (Provisioned IOPS SSD) : more thant 10,000 IOPS
- Magnatic 

Volumes & Snapshots
- Volumes exist on EBS
- Snapshots exist on S3

EBS & Intance Store
- Instance Store volumes: Ephemeral Storage, Can't be stopped
- EBS volumes: can be stopped, rebooted without losing your data

AMI
- AMIs are regional

CloudWatch
- Standard monitoring (5 min) provided freely for ec2 performance monitoring
- Detailed monitoring (1 min) 

Instance Meta-data
- http://169.254.169.254/latest/meta-data/

