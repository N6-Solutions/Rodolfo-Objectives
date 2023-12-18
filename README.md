# Rodolfo-Objectives
This repo outlines the objectives for the Ops 301: Windows Server Deployment
## Objectives
### Windows Server Deployment and Domain Controller Setup
- Develop scripts (PowerShell or other scripting language) to automate the deployment of a Windows Server (Virtual Machine).
- Minimum operations this script should perform:
  - Fully standup all requisite services to make the server into a DC
  - Assign the Windows Server VM a static IPv4 address and a DNS
    - Note: in class we assigned a reserved IP in pfSense, but this script is to assign the VM a static IP.   
  - Rename the Windows Server VM
  - Installs AD-Domain-Services
  - Create an AD Forest, Organizational Units (OU), and users
- Configure the server to act as both a DNS server and a Domain Controller.
- Integrate the new server into the existing network infrastructure.
