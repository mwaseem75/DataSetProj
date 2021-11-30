# Data_APP_Security

## Summary
Web Application build on InterSystems IRIS for Health and Docker to demonstrate Authentication and Authorization process.
By using the application New user can be created programmatically along with roles and SQL privileges, Option to Enable/Disable and Authenticate/Unauthenticate web application. 

## Recommendation 
 * InterSystems Security Basics online course : https://learning.intersystems.com/course/view.php?id=1774 
 * Read related documentations (Authentication and Authorization) : https://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=TSQS_preface
 * Read related documentations (Auditing Guide) : https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=AAUDIT

## Installation with ZPM
```
zpm:USER>zpm "install scw-Patient"
```
## Features
* Demonstrate Authentication,Authorization and Auditing basics
* Create New User by code
* Programatically added audit Log
* Create Role and Assign SQL table priviliges
* Grant all privileges to user by assigning %All role by code
* Enable/Disable Web Terminal Application by code
* Authenticate/Unauthenticate Web Terminal Application by code

## Application Layout
![image](https://user-images.githubusercontent.com/18219467/143904440-21d604b6-43e5-46f6-b19f-0f3292aa5152.png)

## Repo Contents   
* Dockerfile, docker-compose.yml, and Installer.cls to create container
* iris.script, contains script to execute during container initialization 
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
## To Run on macOS:  

```
	git clone https://github.com/mwaseem75/Data_APP_Security.git 
	cd Data_APP_Security 
	docker-compose up -d  
```
Log in with credentials: SuperUser | SYS

# Getting Started
* Releted article on community protal https://community.intersystems.com/post/programmatically-create-users-grant-privileges-enabledisable-and-authenticateunauthenticate-web

* Navigate to http://localhost:52773/csp/user/list.csp for landing page
First of all create New user by cliking "Create TestUser" button. Make sure to login as SUPERUSER OR _SYSTEM in order to create new User.
Newly created user can be viewed from management portal (System > Security Management > User)
![image](https://user-images.githubusercontent.com/18219467/143899649-a1f630de-fff5-4e08-ae11-30185c83b718.png)

* Navigate to http://localhost:52773/csp/user/scw.DataForm.cls data form by using *TestUser | demo*
By clicking search button system will raise error: 	
"ERROR #5580: SQL Privilege Violation: 'User TestUser is not privileged for the operation'"
![image](https://user-images.githubusercontent.com/18219467/143900764-fe45525c-3942-415d-8aa9-e90bc550c3a5.png)

* Navigate to http://localhost:52773/csp/user/list.csp by using SuperUser | SYS and assign read access by clicking "Grant Read Access"
Now navigate back to http://localhost:52773/csp/user/scw.DataForm.cls data form by using *TestUser | demo* and data can be viewed 
and updated successfully

![image](https://user-images.githubusercontent.com/18219467/143901209-ec5d2e19-a6c5-4670-af52-95983fc6f269.png)

* Log in to management portal http://localhost:${port}/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=%25SYS" by using *TestUser | demo*
System will raise the "ERROR #940: Insufficient privilege for operation"
![image](https://user-images.githubusercontent.com/18219467/143904877-714ddd94-bdfb-4fa6-a2bf-e69952fcb24a.png)

* Navigate to http://localhost:52773/csp/user/list.csp for landing page by using SuperUser | SYS and Grant all privileges to TestUser by pressing "Grant All Privilege" button.
Now login to management portal http://localhost:${port}/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=%25SYS" by using *TestUser | demo* and now user has all privileges
![image](https://user-images.githubusercontent.com/18219467/143905675-2415fc00-cb9d-4099-a2ed-e93ecaf151c3.png)

* Navigate to web terminal application by clicking Web Terminal menu option
![image](https://user-images.githubusercontent.com/18219467/143905910-8e65a149-8fc2-48f9-bf95-bf0771aeb6b2.png)

* After providing credentials web terminal application will open
![image](https://user-images.githubusercontent.com/18219467/143906332-e884bc13-488a-409a-aec7-bdfb812f8177.png)

* Let's disable web terminal application by clicking "Disable WebTerminal Application". 
 Now Navigate to web terminal application by clicking Web Terminal menu option and system will display message that application not found
 ![image](https://user-images.githubusercontent.com/18219467/143906819-b37e725d-d023-471f-a065-56b07bf971a5.png)

Web terminal application can be enabled by clicking "Enable WebTerminal Application" button.
 
 * Now Let's disable all the authentications for Web Terminal Application by pressing "Disable WebTerminal Authentication". 
 System will not allow to enter even providing correct credentials
 ![image](https://user-images.githubusercontent.com/18219467/143907300-e6177d2b-5b38-4d67-9b2d-3e11fa19169c.png)

Web terminal application Authentication can be enabled by clicking "Enable WebTerminal Authentication" button.

Thanks

# Special Thanks to:
Evgeny Shvarov for: https://openexchange.intersystems.com/package/secured-rest-api template for guidance



