/* data "aws_kms_key" "roboshop-key" {
  key_id = "alias/roboshop"
} */

data "aws_ssm_parameter" "user" {
  name = "${var.env}.rds.user"
}

data "aws_ssm_parameter" "pass" {
  name = "${var.env}.rds.pass"
}