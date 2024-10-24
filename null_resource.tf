resource "null_resource" "cluster" {
  count = length(var.public_cird_block)  # Adjust as needed for your use case

  provisioner "file" {
    source      = "user-data.sh"
    destination = "/tmp/user-data.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust based on your AMI
      private_key = file("DevSecOps_Key.pem")
      host        = element(aws_instance.public_server.*.public_ip, count.index)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/user-data.sh",
      "sudo /tmp/user-data.sh",
      "sudo apt update",
      "sudo apt install jq unzip -y",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Adjust based on your AMI
      private_key = file("DevSecOps_Key.pem")
      host        = element(aws_instance.public_server.*.public_ip, count.index)
    }
  }

  depends_on = [aws_instance.public_server]  # Ensure the instance is created first
}
