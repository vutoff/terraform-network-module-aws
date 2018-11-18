# Module `network`

## Table of Contents

* [Description](#description)
* [Usage](#usage)
  * [Input parameters](#input-parameters)
  * [Output attributes](#output-attributes)

## Description

The module is used to create VPC and it's basic components

* VPC

* Public Subnets (number is determined from the number of AZ's).

* Public Routing tables.

* Internet Gateway attached to the Public Routing table.

* Private Subnets (number is determined from the number of AZ's).

* Private Routing Tables

* Nat Gateway attached to the routing tables.

* Network ACL that address traffic from VPC to S3.

* Bastion Host

* AWS Subnet groups

## Usage

```yaml
module "network" {
  source       = "../../modules/network"
  main_vars    = "${var.main_vars}"
  network_vars = "${var.network_vars}"
  vpc_cidr     = "${var.vpc_cidr}"
}
```

### Input parameters

* **main_vars** - Mapped variables defining the basic application
  parameters. Defined in the global `variables.tf` file.

* **domains** - Mapped variables defining all the domains.
  Used for defining local search domain as dhcp option.

* **cloudwatch_flow_log** - (optional) Name of a CloudWatch log group
  used to send flow logs to.

* **network_vars** - Mapped variables defining the basic network
  paramters. Defined in the global `variables.tf` file.

  Example:
  ```yaml
  network_vars = {
    availability_zones = ["eu-west-1a", "eu-west-1b"]
    vpc_cidr           = ["10.250.0.0/16"]
  }
  ```

### Output attributes

* Resources created with this module have the following output attributes:

  Attribute                 | Description
  ---                       | ---
  vpc_id                    | ID of the VPC created
  private_subnet_ids        | A list of private subnet ID's created
  private_routing_ids       | A list of private routing table ID's created
  public_subnet_ids         | A list of public subnet ID's created
  public_routing_ids        | A list of prublic routing table ID's created
  private_ec_subnet_group   | A list with private subnets available for Elasticache
  private_rds_subnet        | A list with private subnets available for RDS
  private_rs_subnet         | A list with private subnets available for Redshift
  natgw_public_ips          | A list of EIP's attached to the NAT GW.


* Attribute usage:

  Attributes can be used as input varibles to other modules in the following format:

  ```sh
  ${module.network.<attribute_name>}
  ```
  > **Example**:
  >
  >```sh
  > ${module.network.vpc_id}
  >```
