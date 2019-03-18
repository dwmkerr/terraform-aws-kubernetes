//  Output some useful variables for quick SSH access etc.

output "node-public_ip" {
  value = ["${aws_instance.node.*.public_ip}"]
}
output "node-private_dns" {
  value = "${aws_instance.node.*.private_dns}"
}
output "node-private_ip" {
  value = "${aws_instance.node.*.private_ip}"
}

output "bastion-public_ip" {
  value = "${aws_eip.bastion_eip.public_ip}"
}
output "bastion-private_dns" {
  value = "${aws_instance.bastion.private_dns}"
}
output "bastion-private_ip" {
  value = "${aws_instance.bastion.private_ip}"
}
