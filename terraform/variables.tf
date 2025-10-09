# networking


variable "public_subnet1" {
  description = "CIDR Block for Public Subnet 1"
  default     = "subnet-0598a3e96c936fe35"
}

variable "public_subnet2" {
  description = "CIDR Block for PublicSubnet 1"
  default     = "subnet-04a6f7ef8d5ef2732"
}

variable "cluster_name" {
  type = string
  default = "my-eks-cluster2"
 }
