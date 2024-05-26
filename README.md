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
