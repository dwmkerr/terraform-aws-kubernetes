//  Notes: We could make the internal domain a variable, but not sure it is
//  really necessary.

//  Create the internal DNS.
resource "aws_route53_zone" "internal" {
  name = "kubernetes.local"
  comment = "Kubernetes Cluster Internal DNS"

  vpc {
    vpc_id = "${aws_vpc.kubernetes.id}"
  }

  tags {
    Name    = "Kubernetes Internal DNS"
    Project = "kubernetes"
  }
}

resource "aws_route53_record" "node-a-record" {
  count = "${var.node_count}"
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "node${count.index + 1}.kubernetes.local"
    type = "A"
    ttl  = 300
    records = [
      "${element(aws_instance.node.*.private_ip, count.index)}"
    ]
}
