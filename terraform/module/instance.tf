resource "aws_security_group" "my_instance_sg" {
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["172.0.0.0/8"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["172.0.0.0/8"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["172.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "MKE_HUG_example_04_allow_22-80-443"
    application = "MKE_HUG"
    environment = "example_04_sg"
    role        = "instance security group"
  }
}

resource "aws_launch_template" "instance" {
  name_prefix            = "webserver_template"
  image_id               = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.my_instance_sg.id}"]
  user_data              = "${var.user_data}"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "MKE_HUG_example_04_farm_instance"
      Application = "${var.application}"
      Environment = "${var.environment}"
      Role        = "instance from launch template"
    }
  }
}

resource "aws_autoscaling_group" "my_instance" {
  name                      = "example_04_server_${var.application}"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  termination_policies      = ["OldestLaunchConfiguration", "ClosestToNextInstanceHour"]

  launch_template {
    id      = "${aws_launch_template.instance.id}"
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  vpc_zone_identifier = ["${var.subnets}"]

  tag {
    key                 = "propegation"
    value               = "applied_by_asg"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}
