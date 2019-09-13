data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.03.*"]
  }
}

resource "aws_vpc" "product" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "product"
  }
}

resource "aws_subnet" "private" {
  count             = "${length(local.availability_zones)}"
  cidr_block        = "${element(local.private_cidrs, count.index)}"
  vpc_id            = "${aws_vpc.product.id}"
  availability_zone = "${element(local.availability_zones, count.index)}"

  tags {
    application = "MKE_HUG"
    environment = "tfcloud-${element(local.availability_zones, count.index)}"
    role        = "Landing Zone Private Subnet"
    type        = "private"
  }
}

resource "aws_subnet" "public" {
  count             = "${length(local.availability_zones)}"
  cidr_block        = "${element(local.public_cidrs, count.index)}"
  vpc_id            = "${aws_vpc.product.id}"
  availability_zone = "${element(local.availability_zones, count.index)}"

  tags = {
    application = "MKE_HUG"
    environment = "tfcloud-${element(local.availability_zones, count.index)}"
    role        = "Landing Zone Public Subnet"
    type        = "public"
  }
}
module "autoscaled_instance" {
  source        = "./module/"
  application   = "MKE_HUG"
  environment   = "tfcloud-demo"
  instance_type = "t2.micro"
  subnets       = ["${aws_subnet.private.*.id}"]
  ami_id        = "${data.aws_ami.amazon_linux.id}"
  key_name      = "ec2_demo"
  vpc_id        = "${aws_vpc.product.id}"
}
