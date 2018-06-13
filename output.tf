output "runner1" {
  value = "${aws_instance.runner1.private_ip}"
}
output "runner2" {
  value = "${aws_instance.runner2.private_ip}"
}
output "mainpublic1" {
  value = "${aws_subnet.main-public-1.id}"
}
output "mainpublic2" {
  value = "${aws_subnet.main-public-2.id}"
}
output "mainpublic3" {
  value = "${aws_subnet.main-public-3.id}"
}
output "mainprivate1" {
  value = "${aws_subnet.main-private-1.id}"
}
output "mainprivate2" {
  value = "${aws_subnet.main-private-2.id}"
}
output "mainprivate3" {
  value = "${aws_subnet.main-private-3.id}"
}
output "automatesg" {
  value = "${aws_security_group.automate.id}"
}
