variable "alloydb_cluster_name" {
  type        = string
  description = "AlloyDB Cluster Name"
  default     = "alloydb-demo-cluster"
}

variable "alloydb_primary_name" {
  type        = string
  description = "AlloyDB Primary Name"
  default     = "alloydb-demo-cluster-primary"
}

variable "alloydb_password" {
  type        = string
  description = "AlloyDB Password"
}