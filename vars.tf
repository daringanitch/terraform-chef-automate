variable "AWS_REGION" {
  default = "us-west-2"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey3"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey3.pub"
}
variable "s3_bucket_name" {
  default = "ist-chef-license"
}
variable "aws_iam_role" {
  default = "tr_s3_iam_role"
}
variable "aws_iam_instance_profile" {
  default = "tr_s3_instance_profile"
}
variable "aws_iam_role_policy" {
  default = "tr_s3_iam_role_policy"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-e251209a"
    us-west-2 = "ami-e251209a"
    us-west-1 = "ami-e251209a"
   }
}
