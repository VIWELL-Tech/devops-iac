data "template_file" "instance-user-data" {
  template                = "${file("${path.module}/userdata.tpl")}"
  #template                = "${file("${path.module}/userdata-${var.service_name}.tpl")}"
  vars = {
    environment = var.environment
  }
}