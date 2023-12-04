packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.1"
    }
  }
}


source "amazon-ebs" "ubuntu" {
  profile       = "default"
  ami_name      = "ubuntu-devops-packer-linux-aws"
  instance_type = "m7i-flex.large"
  source_ami    = "ami-0fc5d935ebf8bc3bc" ##ubuntu
  # source_ami   = "ami-05a5f6298acdb05b6"
  ssh_username = "ubuntu"
  # spot_instance_types = "m7i-flex.large"
  spot_price        = "0.040"
  availability_zone = "us-east-1f"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    script       = "script.sh"
    pause_before = "10s"
    timeout      = "10s"
  }
}



