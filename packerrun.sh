packer init .
packer fmt .
packer validate .
packer build aws-ubuntu.pkr.hcl