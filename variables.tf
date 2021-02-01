variable "gcs_name" {
  description = "The gcs bucket name where store tfstate"
  type        = string
  default     = "digibee-test-tfstate"
}

variable "project" {
  description = "The project ID to create the resources in."
  type        = string
  default     = "digibee-lab"
}

variable "network_name" {
  description = "The Network name to create the resources in."
  type        = string
  default     = "digibee-network-internal"
}

variable "subnetwork_name" {
  description = "The Subnetwork name to create the resources in."
  type        = string
  default     = "digibee-subnetwork-internal"
}

variable "realm" {
  description = "Realm name"
  type        = string
  default     = "cyberdyne"
}

variable "region" {
  description = "The region to create the resources in."
  type        = string
  default     = "us-central1"
}

variable "dns_name" {
  description = "The DNS internal region name."
  type        = string
  default     = "digibee-private-zone"
}

variable "source_ranges" {
  description = "The range allow incomming traffic."
  type        = list
  default     = ["0.0.0.0/0"]
}

#variable "ssh_user_name" {
#  description = "SSH User name"
#  type        = string
#}

#variable "ssh_user_key_file" {
#  description = "SSH User key file"
#  type        = string
#  default     = "~/.ssh/google_compute_engine"
#}
