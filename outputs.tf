
output "ec2_private_ip" {
  value = aws_instance.RSA_example.private_ip

}
output "ec2_public_ip"{
  value = aws_instance.RSA_example.public_ip
}