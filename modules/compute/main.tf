resource "aws_instance" "app" {

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash

    mkdir -p /opt/lab15-app

    echo "Hello from Lab 15 Private Ec2" > /opt/lab15-app/index.html

    cat > /etc/systemd/system/lab15-app.service <<'SERVICE'
    [Unit]
    Description=Lab 15 HTTP Application
    After=network.target

    [Service]
    Execstart=/usr/bin/python3 -m http.server 80 --directory /opt/lab15-app
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable lab15-app
    systemctl start lab15-app

  EOF

  tags = {
    Name = "AWS-Infrastructure-App"
  }

}