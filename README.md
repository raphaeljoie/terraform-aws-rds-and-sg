# Blueprint RDS cluster with associated SG

Use the official [`terraform-aws-rds` module](https://www.github.com/terraform-aws-modules/terraform-aws-rds)
to deploy an RDS cluster, and create two **Security Groups**
1. a security group `"sg-rds-${var.name}"` for the instances to listen at port `var.port`
2. a security group `"sg-rds-${var.name}-client"` for the clients to connect to the port `var.port` of the instances

The first security group is only open for connection coming from the second one.

## Usage
```tf
module "db" {
  source = "git::git@github.com:raphaeljoie/terraform-aws-rds-and-sg.git"
  
  name = "my-db"
  vpc_id = var.vpc_id
  
  # ... other parameters, see https://www.github.com/terraform-aws-modules/terraform-aws-rds
  # only the 'name' parameter has been renamed 'db_name'
}
```

## Outputs
all the outputs of https://www.github.com/terraform-aws-modules/terraform-aws-rds, in addition to

| Name | Description |
|------|-------------|
| `[server/client]_security_group_id` | The id of the server/client security group |
| `[server/client]_security_group_name` | The name of the server/client security group |
| `[server/client]_security_group_description` | The description of the server/client security group |
