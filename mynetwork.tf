# Create the mynetwork network
resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = true
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on mynetwork
resource "google_compute_firewall" "mynetwork-allow-http-ssh-rdp-icmp" {
  name    = "mynetwork-allow-http-ssh-rdp-icmp"
  network = google_compute_network.mynetwork.self_link
  source_ranges = [
    "0.0.0.0/0"
  ]

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

# Create the mynet-us-vm instance
module "mynet-us-vm" {
  source              = "./instance"
  instance_name       = "mynet-us-vm"
  instance_zone       = "us-east4-a"
  instance_subnetwork = google_compute_network.mynetwork.self_link
}

# Create the mynet-asia-vm" instance
module "mynet-asia-vm" {
  source              = "./instance"
  instance_name       = "mynet-asia-vm"
  instance_zone       = "asia-east1-b"
  instance_subnetwork = google_compute_network.mynetwork.self_link
}
