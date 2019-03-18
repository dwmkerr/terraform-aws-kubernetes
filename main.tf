//  Setup the core provider information.
provider "aws" {
  region  = "${var.region}"
}

//  Create the Kubernetes cluster using our module.
module "kubernetes" {
  source          = "./modules/kubernetes"
  region          = "${var.region}"
  node_count      = "6"
  amisize         = "t2.medium"
  vpc_cidr        = "10.0.0.0/16"
  subnet_cidr     = "10.0.1.0/24"
  key_name        = "kubernetes"
  public_key_path = "${var.public_key_path}"
  cluster_name    = "kubernetes-cluster"
  cluster_id      = "kubernetes-cluster-${var.region}"
}

output "bastion-public_ip" {
  value = "${module.kubernetes.bastion-public_ip}"
}
