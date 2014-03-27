Server Provisioning
===================	
*******************

## Table of Contents
1. Introduction
2. Overview
3. Chef Basics
4. Chef Advanced
5. Cookbooks and Roles
6. Workflow
7. Examples
**********************************************

## Chef Repository

## Overview
This is a high-level representation of the Chef-based server provisioning framework being deployed
to the new Disaster Recovery Data Center, and eventually, the existing Verizon CaaS infrastructure. 

### Git
This is the Sephora Chef Repository, built atop the latest chef-repo build.    

[Git via SSH] [ssh-git]   
[Git via HTTP] [http-git]   

### Technical Requirements
* RHEL - 5.10+
* Chef Server - 11.0.11
* Chef Client - 11.8.2	

## <a id="introduction"></a>1. Introduction

### What is provisioning?
Automated provisioning allows for servers to be maintained in a consistent state by scripting
server behavior using a Ruby-based DSL. Configuration updates are no longer made to individual 
servers. Behavior is updated and maintained by a central authority, that instructs trusted
clients to install packages, configure the base environment, and write configuration files
based on templates and attributes. [1] [1]

### What is Chef? 
Chef is the leading provisioning tool for physical, virtual, and cloud based deployments. It
contains an embedded Postgres database to maintain the state of references, versions and
dependencies for each server. There is also a rich set of server information, and environment 
variables, available through the environment detection tool, 'OHAI'. [1] [1]

### Why Chef?
Chef, Version 11.0+, is a dramatic leap forward in the capabilities of Chef. There is no longer
'dependency hell' involved in installing chef-client. Chef-client 
[2] [2]

*************************************************

## 2. Overview
The initial implementation of Chef replicates the existing Sephora infastructure found in Verizon CAAS, 
and deploy-tools/metadata. Each existing node will be replicated in Chef, in a source-maintained JSON file, 
and deployed to the Chef Server. 

### Current State
Artifacts are deployed to each environment, using custom scripted 'DeployTools'. 

#### Translating Metadata to Chef
  In addition to scripts/, there are two types of directories found in the root of the metadata folder. In the format:
  
  * *server_type@IP_ADDRESS/*
  * *environment_name/*

  ##### Environments
  Each environment contains node definitions, that contain server names present in the
  root /metadata directory. 

  * Example: ../metadata/qa/apache 
    * apache@10.105.36.13
    * apache@10.105.36.13
    * apache@10.105.36.13

  ##### Server Type
  Each folder contains the configuration data for that specific node. There is always a file
  'instances' that contains the roles for this particular node. Also included are configuration
  files that will overwrite existing configuration. 

  * Example: ../metadata/apache@10.105.36.13
    * ../instances - Contains 'httpd' and 'seo'.
    * ../etc/httpd/conf[.d]/ - Apache config files and directories. 
    * ../etc/seo/conf[d.]/ - SEO config files/directories.   

  ##### Scripts
  Walk directory tree to gather configuration files for Apache, SEO, and JBoss, and push them to remote server via
  scp. 

* User/Group Control
* Deployed from Metadata, Deploytools

### Future State
Provisioning but no deployment. 
  
##### File Structure
  - cookbook/
    - attributes/
      - definitions/
    - files/
      - default/
    - libraries/
    - providers/
    - recipes/ 
    - resources/
    - templates/


### Testing
* Foodcritic - Lint
* 

*************************************************

## 3. Chef Basics

### Clients [14] [14]
Clients are the most basic entity in Chef. Any machine that has achieved a valid connection
to the Chef-Server is considered a client. Any machine that connects to Chef-Server is validated as
a client, this includes workstations, and well as server clients. 

### Nodes [5] [5]
Nodes are individual instances that have been registered with Chef, as managed servers. [5] [5]

### Environments [8] [8]
Environments provide the ability to group nodes, and assign specific versions of cookbooks to 
servers.  

````
name "sandbox"
description "Sandbox environment for Sephora."
cookbook_versions({   
  "sephora-apache", "< 0.11.0"   
  "sephora::default", ""   
})
````

### Roles [9] [9]
Roles define high-level configurations across nodes. They contain a list of Recipes, or other Roles.

### Attributes [6] [6]
Attributes are the central means of configuration in Chef. Attributes can be accessed through
recipes, templates, databags and other attribute files. Attribute precendece is determined by 
this chart. Most of the time 'default' will override an attribute in a parent cookbook.
The 'override' action is used when setting attributes found in 3rd-party or other well-formed
Chef cookbooks.  
![Precedence][10]

#### Default
This is the syntax to define default attributes, for a given Cookbook. 
````
* default['sephora']['apache']['ssl_port'] = 443
````

#### Override
````
* override['sephora']['apache']['ssl_port'] = 443
````

### Databags [13] [13]
Databags are encrypted, or unencrypted, datastructures that can be accessed and searched, globally,
by key/value. They can contain any information needed to configure a server, include 'secrets'. 

Databags can be referenced in an Environment configuration, or much more often, in a Recipe. 

##### Unencrypted   
`# apache_workers = databag_item('apache', 'workers')`   

##### Encrypted   
`# apache_workers = Chef::EncryptedDataBagItem.load("apache", "workers")`   
`# apache_workers["secretKey"]`   

*************************************************

## 4. Chef Advanced

### Monitoring

### Chef GUI

### Chef Backup

### Patterns and Anti-Patterns

* [Chef Anti-Patterns] [7]

### Associated Reading

* [The Dangers of Dry Run Mode] [15]

### Client
    #### Installation

### Server
    #### Installation

*************************************************
 
## 5. Cookbooks and Roles

### Sephora Wrapper Cookbooks
In-house wrappers around 3rd-party cookbooks. 

#### Sephora "Apache" (sephora-apache)
Core additions in this wrapper are mod_jk. 

#### Sephora "Yum" (sephora-yum)
This wrapper includes configuration for `yum.repos.d/` and internal Sephora repositories. 

#### Sephora "Sudo" (sephora-sudo)
This wrapper generates `/etc/sudoers` and `/etc/sudoers.d/ files for validated Sephora developers. 

### Sephora Cookbooks
Core cookbooks for Sephora. 

#### Sephora "Base" (sephora-base)
This cookbook contains recipes, and attributes for all Sephora servers and applications. 
* Yum
* Sudo

#### Sephora "WWW" (sephora-www)
This is the core cookbook for all Apache-based Sephora applications. 
* Apache

#### Sephora "JBoss" (sephora-jboss)
The is the core cookbook for all JBoss-backed Sephora applications.

#### Roles

* `[sephora-base]` - Includes recipe sephora-base::default.
* `[sephora-www]`  - Includes role[sephora-base], and recipe sephora-www::default. 

*************************************************

## 6. Workflow

### Node Types
* WWW
* JBoss
* Mule
* Endeca

### Environments
* Dev
* Dev2
* Dev FE
* QA
* Perf
* EBF
* Production

*************************************************

## 7. Examples

### Preparing a Workstation

#### Getting Started
````
  # curl -L https://www.opscode.com/chef/install.sh | bash
  # echo '10.105.33.26    ph1397401.bwi40g.vzbi.caas' >> /etc/hosts
````

### Using Knife

#### List Operations
##### List Nodes

  `# knife node list`

#### Configuring a Chef Client [11] [11]  
##### Bootstrap a Node
  Here we are specifying a physical server's IP address, it's Verizon FDQN, and the username
  you have sudoer rights to. This is a basic bootstrap - normally the environment option will
  be required.

  `# knife bootstrap IP_ADDRESS -N NODE_NAME --ssh-user USER_NAME --sudo`
  
##### Register a Client Node
  To register a new node, the client requires the 'validation.pem' file and 'client.rb'. The
  permissions file is generated by the Chef Server. It can be copied from the Chef-Server or 
  generated at the command line through a properly configured workstation. The client file
  configures the URL of the Chef-Server. Both files have to be placed on the client. The example
  below uses SCP, but the required configuration files, and the Chef Client, can be added to a 
  golden image, or specified for a vendor installation. 

  * From a Workstation 
  
  `#  cd [...]/chef-repo `   
  `#  knife configure client ./ `   
  `#  scp validation.pem root@NODE_NAME/etc/chef `   
  `#  scp client.rb root@NODE_NAME/etc/chef `   

  * From the Client
  
  `# curl -L https://www.opscode.com/chef/install.sh | bash`   
  `# mkdir /etc/chef `   
  `# chef-client`

##### Add a Recipe or Role to a Node 

  `# knife node run_list add NODE_NAME [RECIPE | ROLE]`

#### Configuring an Apache Node for Commerce [12] [12]

`# knife node create NODE_NAME`

##### node.json
````
{   
   "normal": {   
   },   
   "name": "NODE_NAME",   
   "override": {   
     'sephora' => {   
       'apache' => {   
         'workers' => {   
      	   'worker1' => {'type' => 'ajp13', 'ip' => 'localhost', 'port' => '11209', 'lbfactor' => '', 'cachesize' => '10', 'cache_timeout' => '600', 'socket_keepalive' => '1', 'socket_timeout' => '300'}      
          }    
        }   
      }   
   },   
   "default": {   
   },   
   "json_class": "Chef::Node",   
   "automatic": {   
   },   
   "run_list": [   
      "role[sephora]",   
      "role[estore]"   
   ],   
   "chef_type": "node"   
}
````

#### Add a New JVM Instance
Modify mod_jk attributes to reflect a new worker.   
`# knife node edit APACHE_NODE_NAME`   

##### node.json
````
  ...   
  'worker1' => {'type' => 'ajp13', 'ip' => 'localhost', 'port' => '11209', 'lbfactor' => '', 'cachesize' => '10', 'cache_timeout' => '600', 'socket_keepalive' => '1', 'socket_timeout' => '300'},    
  'worker2' => {'type' => 'ajp13', 'ip' => 'localhost', 'port' => '12209', 'lbfactor' => '', 'cachesize' => '10', 'cache_timeout' => '600', 'socket_keepalive' => '1', 'socket_timeout' => '300'}   
  ...   
````

Modify JVM Instances to reflect a new port.   
`# knife node edit JBOSS_NODE_NAME`   


[1]: http://docs.opscode.com/chef_quick_overview.html "Overview"
[2]: http://docs.opscode.com/chef_why.html "Why Chef?"
[3]: http://docs.opscode.com/chef/resources.html "Resources"
[4]: http://docs.opscode.com/chef/knife.html "Knife" 
[5]: http://docs.opscode.com/essentials_node_object.html "Node"
[6]: http://docs.opscode.com/essentials_node_object.html#attributes "Node - Attributes"
[7]: http://dougireton.com/blog/2013/02/16/chef-cookbook-anti-patterns "Chef Anti-Patterns"
[8]: http://docs.opscode.com/essentials_environments.html "Environments"
[9]: http://docs.opscode.com/essentials_roles.html "Roles"
[10]: http://docs.opscode.com/_images/overview_chef_attributes_table.png "Precedence Chart"
[11]: https://wiki.opscode.com/display/chef/Configuring+Chef+Client "Configuring Chef Client"
[12]: http://docs.opscode.com/knife_node.html#create "Knife Create Node"
[13]: http://docs.opscode.com/essentials_data_bags.html "Data Bags"
[14]: http://docs.opscode.com/essentials_chef_client.html "Chef Client"
[15]: http://blog.afistfulofservers.net/post/2012/12/21/promises-lies-and-dryrun-mode/ "Dangers of Dry Run mode"
[ssh-git]:  ssh://git@code.sephora.com:7999/do/chef-repo.git "Git SSH"
[http-git]: https://gweaver@code.sephora.com/scm/do/chef-repo.git "Git HTTP"  
