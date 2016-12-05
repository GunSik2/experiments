
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

  

