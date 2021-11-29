# Data_APP_Security

## Summary
Web Application build on InterSystems IRIS for Health and Docker to demonstrate Authentication and Authorization process.
By using the application New user can be created programmatically along with roles and SQL privileges, Option to Enable/Disable and Unauthenticate/ Authenticate web application. 

## Recommendation 
 * View online learning course : https://learning.intersystems.com/course/view.php?id=1774 
 * Read related documentations : https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=TSQS_preface


## Features
* Demonstrate Authentication and Authorization process
* Create New User by code
* Create SQL table reader role and assign to user
* Create SQL table writer role and assign to user
* Grant all priviliges to user by assigning %All role by code
* Enable/Disable Web Terminal Application by code
* Authenticate/Unauthenticate Web Terminal Application by code


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

# Thanks to:
Evgeny Shvarov for: https://openexchange.intersystems.com/package/secured-rest-api template for guidance



