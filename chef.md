Server Provisioning
===================	

## Overview
This is a high-level representation of the Chef-based server provisioning framework being deployed
to the new Disaster Recovery Data Center, and eventually, the existing Verizon CaaS infrastructure. 

### Technical Requirements
* RHEL - 5.10+
* Chef Server - 11.0.11
* Chef Client - 11.8.2

## Implementation
### Current State
It's the wild fucking west. Servers are configured by hand. Deployments are done...by hand.  

### Future State
Provisioning but no deployment. 

### Notes
Overview in terms of Sephora.
Adding a resource to a cookbook.

Executive Summary
Goals/Objectives 

## 1. Introduction

### What is provisioning?
Automated provisioning allows for servers to be maintained in a consistent state by scripting
server behavior using a Ruby-based DSL. Configuration updates are no longer made to individual 
servers. Behavior is updated and maintained by a central authority, that instructs trusted
clients to install packages, configure the base environment, and write configuration files
based on templates and attributes. [1] [1]

### What is Chef? 
Chef is the leading provisioning tool for physical, virtual, and cloud based deployments. It
contains an embedded Postgres database to maintain the state of references for each server. There
is also a rich set of server information, and environment variables, available through the 
environment detction tool, 'OHAI'. [2] [2]

## 2. Overview
The initial implentation of Chef replicates the existing Sephora infastructure found in Verizon CAAS, 
and deploy-tools/metadata. Each existing node will be replicated in Chef, in a source-maintained JSON file, 
and deployed to the Chef Server. 

### Current State
* User/Group Control
* Deployed from Metadata, Deploytools

## Future State

## 3. Chef

### Clients

### Nodes

### Attributes

#### Default
#### Override

### Databags

### Environments

### Roles


## 4. Examples

### Preparing a Workstation
### Using Knife

-> This is a 'code' example. 

##### List Nodes

  `# knife node list`

  Provided Omar a document for Network settings. Internal and external for DB servers. Provide Scott and Omar. 
  Pre Reqs.
  Oracle User, Grid User, Java, Port 1521

  Scott: How many of these VLANs are going to be routed vs. non-routed. How many IPs? I am assuming just two. 

  How many IPs to you need per VLAN? The management VLAN already has something segmented out for managed devices.  

  1 color - application servers 
   - storage, EMC storage, HBA based
   Focus on green and the black
   Management VLAN, one per host. 
   Only thing traversing physical connections is VLAN #10. 

Two separate 4 port cards. Bonded for failover. 
Network bond type for Oracle DB servers. LACP. 

* Using 2 port, per card, per host (4-way LACP bond, for public network)
* Private,Private (LACP) (Private, Non-routed, VLAN) 
* Monitoring
* Backup

6x 2960X. 
dRAC? 
iLO?

VNX EMC environment, requires two different servers to make contact EMC. 


[1]: http://docs.opscode.com/chef_quick_overview.html "Overview"
[2]: http://docs.opscode.com/chef_why.html "Why Chef?"
[3]: http://docs.opscode.com/chef/resources.html "Resources"
[4]: http://docs.opscode.com/chef/knife.html "Knife" 
[5]: http://docs.opscode.com/essentials_node_object.html "Node"
[6]: http://docs.opscode.com/essentials_node_object.html#attributes "Node - Attributes"
