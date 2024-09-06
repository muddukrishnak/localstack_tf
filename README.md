# localstack_tf

## AWS Services on LocalStack

#### This repository provides a setup to create and manage AWS services locally using LocalStack. It is designed to help you experiment, learn, and build personal projects without requiring a connection to the actual AWS environment. Whether you're learning cloud development, testing, or building small-scale applications, this repo offers a local AWS environment for streamlined workflows and cost-effective experimentation.

##### Prerequisites

1) python - [https://www.python.org/downloads/](https://)
2) Docker - [https://www.docker.com/products/docker-desktop/](https://)
3) localstack cli - [https://docs.localstack.cloud/getting-started/installation/](https://)
4) tflocal cli - [https://pypi.org/project/terraform-local/](https://)
5) awslocal cli - [https://pypi.org/project/awscli-local/](https://)

##### Setup

Step 1: Add localstack cli path to environmantal variables.

Step 2: Start Docker.

Step 3: Start localstack, run below command in powershell. Don't close the window after running
```
localstack start
```

Step 4: On the other powershell window test with below commands to see if aws services are up.
```
awslocal s3 mb s3://my-local-bucket
awslocal s3 ls
awslocal s3 rb s3://my-local-bucket
```

Step 5: Write your terraform scripts and use below commands in terraform scripts path for deploying services.
```
tflocal init
tflocal apply
```
