
variable "ec2_ami" {
  description = "The AMI to use for the EC2 instance"
  default     = "ami-07a00cf47dbbc844c"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
  default     = "terraform-instance"
  type        = string
}
