variable "AWS_REGION" {
  default = "us-west-2"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey2"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey2.pub"
}
variable "web_iam_role" {
  default = "s3-bucket-role-09"
}
variable "s3_iam_role_policy" {
  default = "s3-role-policy-09"
}
variable "web_instance_profile" {
  default = "profile-09"
}
variable "web_iam_role_policy" {
  default = "policy-09"
}
variable "s3_iam_role" {
  default = "s3-role-09"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-e251209a"
    us-west-2 = "ami-e251209a"
    us-west-1 = "ami-e251209a"
   }
}
