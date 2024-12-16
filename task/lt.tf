resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-launch-"
  image_id      = "ami-0451f2687182e0411"  # Amazon Linux 2 AMI in ap-south-1
  instance_type = "t2.micro"
  key_name      = "london"  # Replace with your actual key name

  network_interfaces {
    security_groups             = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Welcome to the Auto-Scaling Web Server</h1>" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebServer"
    }
  }
}
