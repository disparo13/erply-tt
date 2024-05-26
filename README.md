# erply-tt

NB: The provided example project ([https://github.com/sujoyduttajad/Landing-Page-React](https://github.com/sujoyduttajad/Landing-Page-React)) is abandoned, outdated, and has severe critical vulnerabilities, so I took a more recent one (https://github.com/issaafalkattan/React-Landing-Page-Template).

# Infrastructure description

The application is preliminarily packed into the container and uses Docker to run. The network infrastructure comprises **VPC**, three public and three private subnets. **Application Load Balancer** utilizes three public subnets, while Autoscaling Group creates and runs **EC2** instances inside the private subnets. Thus, all traffic passes from the ALB’s port 80 and terminates on the EC2 port 8080. The infrastructure also includes a single **NAT gateway** and, of course, **the Internet gateway.**

# Codebase

The whole setup is ensured by **Terraform** code wrapped into the **Terragrunt** configuration. Terragrunt creates an S3 bucket to store the state file and a DynamoDB table to provide the lock during the code execution, so you don't need to bother about it. Moreover, it eliminates the code repetitions, keeps code DRY, makes it more structured, and allows us to execute code by parts without the need to touch the parts that weren't changing. For example - we can only change the Autoscaling Group configuration, and its code appliance will take just a couple of seconds instead of minutes to check the other parts of the setup, like VPC and ALB.

Under the hood it also utilizes terraform modules from the registry:

https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest

https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/latest

# HOWTO

## Configuration

Here's the *env.hcl* example:

```
locals {
  #
  # tier - basically - a name of your environment
  # region - the region, where the configuration will be deployed
  # backend - is the path to your state file, you should not change it
  #
  tier    = "stage"
  region  = "us-east-1"
  backend = "${local.tier}-${local.region}-tfstate"

  # Here comes the autoscaling group configuration
  ag_min_size     = 1
  ag_max_size     = 1
  ag_desired_size = 1

  # The docker image to deploy
  image = "disparo/app-react:latest"

  # The instance type for your deployment
  worker_node_instance_type = "t2.micro"

  # CIDR for the configurable VPC
  # You should stay inside the /16 address space
  # the rest will be configured automatically
  vpc_cidr = "10.2.0.0/16"

  # Whatever tags you want to set for your deployment
  tags = {
    Tier      = local.tier
    Region    = local.region
    Terraform = true
  }
}
```

## Deploy

Please ensure you configured the API access for your AWS account and have installed the latest versions of **Terraform** and **Terragrunt**, then
go to the environment directory

```
cd stage
```

and run

```
terragrunt run-all apply --terragrunt-non-interactive
```

Terragrunt will create all the needed infrastructure, including the S3 bucket to store the state and DynamoDB table, to ensure the execution lock.
Just so you know, choosing the cheaper instances, like *t2.micro*, will take longer for the application to warm up. In my case, it took up to 15 minutes
to become available.

To get the ALB DNS address:

```
cd alb
terragrunt output alb_dns_name | tr -d '"'
```

In my case it was *stage-react-app-220788634.us-east-1.elb.amazonaws.com*, so the application will be available by the address:
**http://stage-react-app-220788634.us-east-1.elb.amazonaws.com:80**

## Scaling up and down

In the *env.hcl* file edit the settings for 

```
  ag_min_size     = 1
  ag_max_size     = 1
  ag_desired_size = 1
```

then re-apply the *ag* part:

```
cd ag
terragrunt apply
```

## Destroying configuration

Go to the environment directory

```
cd stage
```

and run

```
terragrunt run-all destroy
```

# Structure

* modules - directory with the local Terraform modules that we are calling from the Terragrunt
* prod - a production environment configuration
* stage - a staging environment configuration

Every environment consists of:
* vpc - deployment part for the VPC
* alb - deployment part for the Application Load Balancer
* ag - deployment part for the autoscaling group
* env.hcl - the main configuration file for the environment

```text

├── modules
│   ├── app-lb
│   │   ├── alb.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── autoscaling-group
│   │   ├── asg.tf
│   │   ├── security-groups.tf
│   │   ├── userdata.tfpl
│   │   └── variables.tf
│   └── network
│       ├── outputs.tf
│       ├── variables.tf
│       └── vpc.tf
├── prod
├── stage
│   ├── ag
│   │   └── terragrunt.hcl
│   ├── alb
│   │   └── terragrunt.hcl
│   ├── env.hcl
│   └── vpc
│       └── terragrunt.hcl
└── terragrunt.hcl

```
