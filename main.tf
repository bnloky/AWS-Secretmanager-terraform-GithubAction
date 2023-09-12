provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "terraformbackedstatefilestore"
    key            = "terraform.tfstate"
    region         = "ap-south-1"  # Replace with your desired region
    encrypt        = true
  }
}

# Firstly create a random generated password to use in secrets.
 
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "Lokesh@123456789"
}
 
# Creating a AWS secret for database master account (Masteraccoundb)
 
resource "aws_secretsmanager_secret" "secretmasterDB" {
   name = "Masteraccoundb"
}
 
# Creating a AWS secret versions for database master account (Masteraccoundb)
 
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id
  secret_string = <<EOF
   {
    "username": "adminaccount",
    "password": "${random_password.password.result}"
   }
EOF
}
 
# Importing the AWS secrets created previously using arn.
 
data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.secretmasterDB.arn
}
 

