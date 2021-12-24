# go-hello-world
Simple HTTP Hello World in Golang

## Prerequisites
1. Create an IAM user **s4l-terraform** to apply the AWS infrastructure for this project and the S3 bucket and DynamoDB table for the terraform tfstate bucket.
running terraform with a programmatic access user with at least IAM full access permission.
```
  $ terraform -chdir=pre-install apply
```
2. Get the `AWS_ACCESS_KEY_ID` and the `AWS_SECRET_ACCESS_KEY` from the terraform output and write them down to the `~/.aws/credentials` file:
```
[s4l-terraform]
aws_access_key_id = <your_acces_key_id>
aws_secret_access_key = <your_secret_access_key>
```
And add the configuration for the `s4l-terraform` user account in the `~/.aws/config` file:
```
[profile s4l-terraform]
region = eu-west-1
output = json
```

# Build

### Requirements
- docker installed and running

### How to build
From the root of this repository run `make docker-build` and the binary will be located in `./out/` directory (the binary will be compiled for `linux amd64` platform only).

# Run
Just execute the binary and the webserver will be available at port `80`

### Endpoints

- `/` -> Hello World
- `/health` -> health check
