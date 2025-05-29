terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
      #version = "= 1.0"
    }
  }
}

locals {
  organization_name = "lkqjbgz"
  account_name      = "tw57115"
  private_key_path  = "C:\Users\KCHAOUAL\Downloads\Snowflake - terraform\snowflake_tf_snow_key.p8"
}

provider "snowflake" {
    organization_name = local.organization_name
    account_name      = local.account_name
    user              = "TERRAFORM_SVC"
    role              = "SYSADMIN"
    authenticator     = "SNOWFLAKE_JWT"
    private_key       = file(local.private_key_path)
}

resource "snowflake_database" "tf_db" {
  name         = "TF_DEMO_DB"
  is_transient = false
}

resource "snowflake_warehouse" "tf_warehouse" {
  name                      = "TF_DEMO_WH"
  warehouse_type            = "STANDARD"
  warehouse_size            = "XSMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

resource snowflake_view view {
  database = "SNOWFLAKE_LEARNING_DB"
  schema   = "KHALIL_LOAD_SAMPLE_DATA_FROM_S3"
  name     = "test_view"

  comment = "comment"

  statement  = <<-SQL
    select * from MENU;
SQL
  or_replace = true
  is_secure  = false
}