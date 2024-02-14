variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "os" {
  default = "ami-053b0d53c279acc90"
}

variable "instance_size" {
  default = "t2.micro"
  
}

