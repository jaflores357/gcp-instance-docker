
#---------------------------------
# Terraform Version
#---------------------------------

terraform {
  required_version = ">= 0.13"
}

#---------------------------------
# Providers
#---------------------------------

provider "google" {
  version = "~> 3.40"
  region  = var.region
  project = var.project
}

provider "google-beta" {
  version = "~> 3.40"
  region  = var.region
  project = var.project
}

#---------------------------------
# data
#---------------------------------

data "google_compute_zones" "available" {}


data "google_compute_network" "vpc_network" {
  name    = var.network_name
  project = var.project
}

data "google_compute_subnetwork" "vpc_subnetwork" {
  name    = var.subnetwork_name
  region  = var.region
  project = var.project
}

data "google_dns_managed_zone" "internal_dns_zone" {
  name    = var.dns_name
  project = var.project
}

#---------------------------------
# Firewall
#---------------------------------


resource "google_compute_firewall" "internal_allow_all" {
  name        = "${var.realm}-internal-allow-all"
  project     = var.project
  network     = data.google_compute_network.vpc_network.self_link
  direction   = "INGRESS"
  source_ranges = [data.google_compute_subnetwork.vpc_subnetwork.ip_cidr_range,]
  priority = "1000"
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "iap_allow_ingress" {
  name          = "${var.realm}-iap-allow-ssh-ingress"
  project       = var.project
  network       = data.google_compute_network.vpc_network.self_link
  target_tags   = ["allow-ssh"]
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20", "130.211.0.0/22"]
  priority      = "1000"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "external_allow_ingress" {
  name          = "${var.realm}-internal-allow-ssh-ingress"
  project       = var.project
  network       = data.google_compute_network.vpc_network.self_link
  target_tags   = ["allow-ssh"]
  direction     = "INGRESS"
  source_ranges = var.source_ranges
  priority      = "1000"
  allow {
    protocol = "tcp"
    ports    = ["22", "4440"]
  }
}


#---------------------------------
# Instances
#---------------------------------

resource "google_compute_instance" "app" {
  project      = var.project
  name         = "dgb-${var.realm}-1"
  machine_type = "e2-medium"
  zone         = data.google_compute_zones.available.names[0]

  tags = [
    "allow-ssh",
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata_startup_script = file("scripts/app_startup_script.sh")

  network_interface {
    network    = data.google_compute_network.vpc_network.self_link
    subnetwork = data.google_compute_subnetwork.vpc_subnetwork.self_link

    access_config {
      // Ephemeral IP
    }
  }
}
