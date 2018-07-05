variable "AWS_REGION" {
  default = "us-west-2"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey2"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey2.pub"
}
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-e251209a"
    us-west-2 = "ami-e251209a"
    us-west-1 = "ami-e251209a"
   }
}
