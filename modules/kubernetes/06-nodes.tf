//  Create an SSH keypair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

//  Create the node userdata script.
data "template_file" "setup-node" {
  template = "${file("${path.module}/files/setup-node.sh")}"
  vars {
    availability_zone = "${data.aws_availability_zones.azs.names[0]}"
  }
}

# // Create Elastic IP for the nodes
# resource "aws_eip" "node1_eip" {
  # instance = "${aws_instance.node1.id}"
  # vpc      = true
# }

# resource "aws_eip" "node2_eip" {
  # instance = "${aws_instance.node2.id}"
  # vpc      = true
# }

resource "aws_instance" "node" {

  # This will create 4 instances
  count = "${var.node_count}"

  ami                  = "${data.aws_ami.ubuntu_16.id}"
  instance_type        = "${var.amisize}"
  subnet_id            = "${aws_subnet.public-subnet.id}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes-instance-profile.id}"

  # TODO: eliminating till we get ssh working...
  # user_data            = "${data.template_file.setup-node.rendered}"

  vpc_security_group_ids = [
    "${aws_security_group.kubernetes-vpc.id}",
    "${aws_security_group.kubernetes-public-ingress.id}",
    "${aws_security_group.kubernetes-public-egress.id}",
  ]

  //  We need at least 30GB for Kubernetes, let's be greedy...
  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Storage for Docker, see:
  # https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 80
    volume_type = "gp2"
  }

  key_name = "${aws_key_pair.keypair.key_name}"

  //  Use our common tags and add a specific name.
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Kubernetes Node ${count.index + 1}"
    )
  )}"
}
