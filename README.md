# Terraform + AWS Tutorial 101

Build, change, and destroy AWS infrastructure using Terraform. Step-by-step, command-line tutorials will walk you through the Terraform basics for the first time. https://learn.hashicorp.com/collections/terraform/aws-get-started

## Install Terraform

Install using homebrew
```shell
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
$ brew upgrade hashicorp/tap/terraform
$ terraform -install-autocomplete
$ terraform -version
```

## Local test
The Terraform tutorial uses the Docker provider for assessing everything is
ready on the local system. This approach also requires less configuration
avoids the risk of creating infrastructure on the cloud, that, depending
on the usage, might be charged.

```shell
$ cd 01-docker
$ # see main.tf

$ # create resources
$ terraform init
$ terraform apply

$ # see results
$ curl localhost:8000
$ docker ps

$ # release resources
$ terraform destroy
$ cd ..
```

## AWS client tool (`aws`)
In order to use AWS services without storing credentials inside the project,
I opted to configure a profile on the AWS client tool.

It was useful to set the environment variable `AWS_PROFILE` to this profile,
because I could clearly see the current AWS context on my
[prompt](https://starship.rs/) and I could ran the usual tools to assess the
changes on AWS infrastructure. Other common tools (like
[direnv](https://direnv.net/#/)) can be used to set its appropriate value,
depending on the current directory.

```shell
$ export AWS_PROFILE=MY_PROFILE
$ aws configure --profile $AWS_PROFILE # set the credentials
$ aws sts get-caller-identity          # check the current context
```

## AWS EC2

```shell
$ cd 02-aws-ec2

$ # initialize / validate
$ terraform init
$ terraform fmt
$ terraform validate

$ # create resources
$ terraform apply

$ # see results
$ terraform show
$ terraform state list
$ aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | (.State.Name + ":" + .InstanceType + ":" + .InstanceId)'

$ # release resources
$ terraform destroy
$ cd ..
```

## AWS Lambda

The following implements a lambda functions that returns information about its
runtime.

```js
// @index.js
// create ZIP file: `zip lambda-hello-js.zip index.js`

console.log('lambda-hello-js: loading');

exports.handler = async (event, context) => {
    console.log('lambda-hello-js: running');

    const body = {
        message: 'hello from lambda-hello-js!',
        event,
        env: process.env,
    }

    const response = {
        statusCode: 201,
        body: JSON.stringify(body)
    }

    return response
};

```

The following commands create a disconnected Lambda function on AWS. Although
it _can_ be tested it's only accessible by the AWS client tool or AWS console.

```shell
$ cd 03-aws-lambda

$ # zip the function payload (these names are bound on tf files)
$ zip hello-lambda-js.zip index.js

$ # initialize / validate
$ terraform init; terraform fmt; terraform validate

$ # create resources
$ terraform apply

$ # list all lambda functions
$ aws lambda list-functions | jq -c '.Functions[].FunctionName'

$ # invoke the function created
$ aws lambda invoke response.json --function-name=lambda-hello-js --log-type=Tail --payload="$(base64 <<< '{"my-foo": "my-bar"}')" | tee log.json

$ # parse the result -- verify the object returned comply with the AWS API Gateway requirements
$ jq '.statusCode' response.json

$ # parse the result -- from json encoded with escape characters (i.e \")
$ jq '.body | fromjson' response.json

$ # parse the logs -- from base64 encoded text into json value
$ jq -c -r '.LogResult' log.json | base64 -D

$ # release resources
$ rm response.json log.json
$ terraform destroy
$ cd ..
```
