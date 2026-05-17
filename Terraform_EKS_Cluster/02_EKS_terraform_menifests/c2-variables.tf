# -----------------------------------------------------------------------
# AWS Region (Used in provider block)
# -----------------------------------------------------------------------
variable "aws_region" {
  description = "AWS Region to deploy resources"
  type = string
  default = "us-east-1"
}

# -----------------------------------------------------------------------
# Environment and Business division info
# -----------------------------------------------------------------------
variable "environment_name" {
  description = "Environment name used in resource names and tags"
  type = string
  default = "dev"
}

variable "business_division" {
  description = "Business division in the large org this infra belongs to"
  type = string
  default = "retail"
}

# -----------------------------------------------------------------------
# EKS Cluster configuration
# -----------------------------------------------------------------------
variable "cluster_name" {
  description = "Name of the cluster"
  type = string
  default = "eksdemo"
}

variable "cluster_version" {
  description = "kubernetes minor version to use for the EKS cluster e.g 1.28"
  type = string
  default = null
}

variable "cluster_service_ipv4_cidr" {
  description = "Service CIDR range for kubernetes service, Leave null to use AWS default"
  type = string
  default = null
}

variable "cluster_endpoint_private_access " {
  description = "Whether to enable private access to EKS control Plane"
  type = bool
  default = false
}

variable "cluster_endpoint_public_access " {
  description = "Whether to enable public access to EKS control Plane"
  type = bool
  default = true
}

variable "cluster_endpoint_public_access_cidrs " {
  description = "List of CIDR blocks allowed to access public EKS Endpoint"
  type = list(string)
  default = ["0.0.0.0/0"]
}

# -----------------------------------------------------------------------
# Common TAGs
# -----------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply EKS and related resources"
  type = map(string)
  default = {
    "Terraform" = "true"
  }
}

# -----------------------------------------------------------------------
# EKS nodegroup configuration
# -----------------------------------------------------------------------
variable "node_instance_type" {
  description = "List of EC2 instance types for the node group"
  type = list(string)
  default = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "instance capacity type: ON_DEMAND or SPOT"
  type = string
  default = "ON_DEMAND"
}

variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type = number
  default = 20
}