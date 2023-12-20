# Ops 301: Windows Server Deployment Objectives

This repository outlines the objectives for the Ops 301: Windows Server Deployment.

## Objectives

### Windows Server Deployment and Domain Controller Setup

Develop scripts (PowerShell or other scripting language) to automate the deployment of a Windows Server (Virtual Machine).

Minimum operations this script should perform:

- Fully standup all requisite services to make the server into a DC.
- Assign the Windows Server VM a static IPv4 address and a DNS. (Note: In class, we assigned a reserved IP in pfSense, but this script is to assign the VM a static IP.)
- Rename the Windows Server VM.
- Install AD-Domain-Services.
- Create an AD Forest, Organizational Units (OU), and users.
- Configure the server to act as both a DNS server and a Domain Controller.
- Integrate the new server into the existing network infrastructure.

## Scripts Overview

1. **Project3print.ps1**
   - **Description:** This script is used to print the current system and network configuration of the Windows Server. It's designed to be run both before and after the execution of the other two scripts to capture and compare the system's state, allowing for verification of changes made during the setup process.
   - [GitHub Link](https://github.com/N6-Solutions/Rodolfo-Objectives/blob/main/Project3print.ps1)

2. **Project3a.ps1**
   - **Description:** `Project3a.ps1` is responsible for the initial setup of the Windows Server. This includes configuring network settings (such as setting a static IP address and DNS), renaming the server, installing Active Directory Domain Services, and setting up the server as a Domain Controller.
   - [GitHub Link](https://github.com/N6-Solutions/Rodolfo-Objectives/blob/main/Project3a.ps1)

3. **Project3b.ps1**
   - **Description:** The `Project3b.ps1` script is focused on further configuring Active Directory. It involves creating specific Organizational Units (OUs) and user accounts within those OUs. Each user is assigned to an OU based on their department, and account properties like usernames, logon names, and passwords are set.
   - [GitHub Link](https://github.com/N6-Solutions/Rodolfo-Objectives/blob/main/project3b.ps1)

## Execution Order

Follow these steps to deploy the Windows Server:

1. Run `Project3print.ps1` to document the server's initial state.
2. Execute `Project3a.ps1` for basic server and Active Directory setup.
3. Follow with `Project3b.ps1` for detailed Active Directory configurations.
4. Finally, run `Project3print.ps1` again to verify the changes.

## Resources

Here are some additional resources to help you with Windows Server deployment and Active Directory management:

- [YouTube Tutorial: Windows Server Deployment](https://www.youtube.com/watch?v=0tONNzREopw)
- [Microsoft Docs: Active Directory Module](https://learn.microsoft.com/en-us/powershell/module/activedirectory/?view=windowsserver2022-ps)
- [Microsoft Docs: Introduction to Active Directory Administrative Center (ADAC) Enhancements](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/adac/introduction-to-active-directory-administrative-center-enhancements--level-100-)
- [OpenAI Community Chat: Windows Server Deployment Discussion](https://chat.openai.com/share/0640ed33-2e71-4fe3-a351-0a4faeacd9cf)
