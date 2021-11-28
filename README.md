# Data_APP_Security

## Summary
Web Application build on InterSystems IRIS for Health and Docker. 
Demonstrate Authentication and Authorization process. Create users, grant roles and grant privileges programmatically, Enable/Disable Application.

This application is derived from secured-rest-api template : https://openexchange.intersystems.com/package/secured-rest-api 

Recommended for use with online learning course: https://learning.intersystems.com/course/view.php?id=1774


## Features
* Demonstrate Authentication and Authorization process
* Create New User programmatically
* Grant roles programmatically
* Enable/Disable Application


## Repo Contents   
* Dockerfile, docker-compose.yml, and Installer.cls to create container
* iris.script, contains script to execute during container initialization including 
  Installing and importing TestRanges
* /src with source files 
* /.vscode/settings.json for automatic server connections when opened in VS Code.


## Requirements:  
* [Docker desktop]( https://www.docker.com/products/docker-desktop)
* Get the latest InterSystems IRIS for Health image for use in the Dockerfile: https://hub.docker.com/_/intersystems-iris-for-health  

## To Run on Windows:  
```
	git clone https://github.com/mwaseem75/Data_APP_Security.git  
	cd Data_APP_Security  
	docker-compose up -d  
	
```
Log in with credentials: SuperUser | SYS

## To Run on macOS:  

```
	git clone https://github.com/mwaseem75/Data_APP_Security.git 
	cd Data_APP_Security 
	docker-compose up -d  
	
```
Log in with credentials: SuperUser | SYS



# Getting Started

Navigate to http://localhost:52773/csp/user/list.csp for langindg page




