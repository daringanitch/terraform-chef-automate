variable "AWS_REGION" {
  default = "us-west-1"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}
variable "iam_role" {
  default = "s3-bucket-role-09"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-e251209a"
    us-west-2 = "ami-e251209a"
    us-west-1 = "ami-e251209a"
   }
}
