resource "aws_network_interface" "mgmt_nic1" {
  subnet_id   = aws_subnet.external1.id
  private_ips = [var.chkp_mgmt_private_ip]
  security_groups = [aws_security_group.permissive.id]
  source_dest_check = false
  tags = {
    Name = "R81Mgmt_external_network_interface"
  }
}

resource "aws_network_interface" "mgmt_nic2" {
  subnet_id   = aws_subnet.internal1.id
  private_ips = [var.chkp_mgmt_private_ip2]
  security_groups = [aws_security_group.permissive.id]
  source_dest_check = false
  tags = {
    Name = "R81Mgmt_internal_network_interface"
  }
}

# Create Check Point Management Server
resource "aws_instance" "CHKP_Management_Server" {
  tags = {
 	Name = "R81_Standalone"
       }
  ami           = data.aws_ami.chkp_ami.id
  instance_type = var.chkp_instance_size
  key_name      = var.key_name
  user_data     = file("customdata.sh")
  network_interface {
      network_interface_id = aws_network_interface.mgmt_nic1.id
      device_index = 0
      }
      network_interface {
          network_interface_id = aws_network_interface.mgmt_nic2.id
          device_index = 1
          }
    }

#Create EIP for the Check Point Management Server
resource "aws_eip" "CHKP_Management_EIP" {
  network_interface = aws_network_interface.mgmt_nic1.id
  vpc      = true
} 