/// Class to deploy roles and users
Class scw.Security
{

///Create TestUser with password demo and log the record in audit LOG 
ClassMethod CreateUser() As %String
{
        
    &sql(CREATE USER TestUser IDENTIFY BY demo)
    if SQLCODE < 0 
	{
		//in case of error return message
		DO ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
		Return %msg
	}
	else
	{
		Do $SYSTEM.Security.Audit("%System","%Security","UserChange","User:TestUser | Password:demo","Audit Log inserted from Data_APP_Security")		                        
		Return "TestUser with password demo is created"	
	}
}

/// Create ReadWrite Role
ClassMethod GrantRoles() As %String
{
      
    &sql(CREATE ROLE ReadWrite)
    if SQLCODE < 0 
	{
		//in case of error return message
		DO ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
		Return %msg
	}
    
    &sql(GRANT SELECT,UPDATE,INSERT ON scw.Patient TO ReadWrite)
     if SQLCODE < 0 
	{
		//in case of error return message
		DO ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
		Return %msg
	}
    
    &sql(GRANT ReadWrite To TestUser)
     if SQLCODE < 0 
	{
		//in case of error return message
		DO ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
		Return %msg
	}
    
    Return "Role is created and granted to TestUser successfully"
}

/// Grant %All to TestUser
ClassMethod GrantAll() As %String
{
     
    &sql(GRANT %All To TestUser)
     if SQLCODE < 0 
	{
		//in case of error return message
		DO ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
		Return %msg
	}
    Return "Role %ALL is granted to TestUser successfully"
}

/// Disable Web terminal web application
ClassMethod DisableWT() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set sts = App.Enabled
    if sts = 0 
    {
	    return "Web Terminal application already Disabled"
	}
	set App.Enabled = 0
    if App.%Save() = sc 
    {
	    return "Web Terminal application Disabled successfully"
	 }
	 else
	 {
		return "Error while disabling Web Terminal Application"
	 }
}

/// Enable Web terminal web application
ClassMethod EnableWT() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set sts = App.Enabled
    if sts = 1 
    {
	    return "Web Terminal application already Enabled"
	}
	set App.Enabled = 1
    if App.%Save() = sc 
    {
	    return "Web Terminal application Enabled successfully"
	 }
	 else
	 {
		return "Error while enabling Web Terminal Application"
	 }
}

/// Unauthenticate Web terminal web application
ClassMethod Unauth() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set sts = App.AutheEnabled
    if sts = 0
    {
	    return "Web Terminal Web Application Authentication already Disabled" 
	}
    Set App.AutheEnabled=0
     if App.%Save() = sc 
    {
	    return "Web Terminal application Authentication Disabled"
	 }
	 else
	 {
		return "Error while disabling Web Terminal Application Authentication"
	 }
}

/// Authenticate Web terminal web application
ClassMethod Auth() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set sts = App.AutheEnabled
    if sts = 32
    {
	    return "Web Terminal Web Application Authentication already Enabled" 
	}
    Set App.AutheEnabled=32
     if App.%Save() = sc 
    {
	    return "Web Terminal application Authentication Enabled"
	 }
	 else
	 {
		return "Error while enabling Web Terminal Application Authentication"
	 }
}

}
