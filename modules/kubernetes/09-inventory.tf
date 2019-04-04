//  Collect together all of the output variables needed to build to the final
//  inventory from the inventory template.
data "template_file" "inventory" {
  template = "${file("${path.cwd}/inventory/hosts.ini.template")}"
  vars {
    access_key = "${aws_iam_access_key.kubernetes-aws-user.id}"
    secret_key = "${aws_iam_access_key.kubernetes-aws-user.secret}"
    # TODO: this requires variable interpolation in templates, ouch...
    # node_hostnames = ["${aws_instance.node.*.private_dns}"]
    cluster_id = "${var.cluster_id}"
  }
}

//  Create the inventory.
resource "local_file" "inventory" {
  content     = "${data.template_file.inventory.rendered}"
  filename = "${path.cwd}/inventory/hosts.ini"
}
