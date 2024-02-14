#  Running Terraform script → for RDS Clone with Route create CNAME Record in Route 53.

provider "aws" {
  region = "us-east-1" # Specify your AWS region
  profile = "default"
}

# Fetch data of the existing Aurora cluster
data "aws_rds_cluster" "existing_cluster" {
  cluster_identifier = "uat-edge-replica-release-auth0-cluster-cluster" # Replace with your existing cluster identifier
}

# Create a new Aurora MySQL cluster as a clone
resource "aws_rds_cluster" "clone_cluster" {
  cluster_identifier          = "uat-clone-cluster" # Specify a unique identifier for the clone
  engine                      = data.aws_rds_cluster.existing_cluster.engine
  engine_version              = data.aws_rds_cluster.existing_cluster.engine_version
  database_name               = data.aws_rds_cluster.existing_cluster.database_name
  master_username             = data.aws_rds_cluster.existing_cluster.master_username
  master_password             = "admin123" # Replace with a secure password
  # snapshot_identifier         = data.aws_rds_cluster.existing_cluster.db_cluster_snapshot_identifier
  skip_final_snapshot         = true
  apply_immediately           = true
  db_subnet_group_name        = data.aws_rds_cluster.existing_cluster.db_subnet_group_name
  vpc_security_group_ids      = data.aws_rds_cluster.existing_cluster.vpc_security_group_ids

  # Other configurations as necessary, like backup, maintenance windows, etc.
}

# Manually specify each Aurora cluster instance to clone
resource "aws_rds_cluster_instance" "clone_instance1" {
  identifier                 = "uat-clone-instance" # Set a unique identifier for the first clone instance
  cluster_identifier        = aws_rds_cluster.clone_cluster.id
  instance_class             = "db.r5.large" # Replace with the instance class of your existing cluster instance
  engine                     = data.aws_rds_cluster.existing_cluster.engine
  engine_version             = data.aws_rds_cluster.existing_cluster.engine_version
  publicly_accessible        = true
  # Other configurations as necessary
} 

resource "aws_route53_record" "rds_clone_record" {
  zone_id = "Z06642162AE191X086SZB"
  name    = "uat-clone-rds"
  type    = "CNAME"
  records = [aws_rds_cluster.clone_cluster.endpoint]
  ttl     = 300
}

resource "aws_route53_record" "rds_clone_read_record" {
  zone_id = "Z06642162AE191X086SZB"
  name    = "uat-clone-ro-rds"
  type    = "CNAME"
  records = [aws_rds_cluster.clone_cluster.reader_endpoint]
  ttl     = 300
}



#------------------------------------------------------------------------------

# # Delete RDS cluster instance

# provider "aws" {
#   region = "us-east-1" # Replace with your AWS region
# }

# resource "aws_rds_cluster" "aurora_cluster" {
#   cluster_identifier      = "clone-cluster-identifier" # Replace with your cluster identifier
#   engine                  = "aurora-mysql"
#   engine_version          = "5.7.mysql_aurora.2.11.2" # Specify the engine version
#   database_name           = "mydb" # Replace with your database name
#   master_username         = "app_user" # Replace with your username
#   master_password         = "WE!U5-)Pn[B>^aad@" # Replace with your password
#   skip_final_snapshot     = true
# }

# resource "aws_rds_cluster_instance" "aurora_instances" {
#   count               = 1 # Number of instances
#   identifier          = "clone-instance-1-${count.index}"
#   cluster_identifier  = aws_rds_cluster.aurora_cluster.id
#   instance_class      = "db.r5.large" # Specify the instance class
#   engine              = "aurora-mysql"
#   engine_version      = "5.7.mysql_aurora.2.11.2" # Specify the engine version
# }
