/// Class to deploy roles and users
Class scw.Security
{

/// Create TestUser 
ClassMethod CreateUser() As %Status
{
    Set sc = $$$OK
    // 
    &sql(CREATE USER TestUser IDENTIFY BY demo)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    Return sc
}

/// Create ReadWrite Role
ClassMethod GrantRoles() As %Status
{
    Set sc = $$$OK
    
    &sql(CREATE ROLE ReadWrite)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    &sql(GRANT SELECT,UPDATE,INSERT ON scw.Patient TO ReadWrite)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    &sql(GRANT ReadWrite To TestUser)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    Return sc
}

/// Grant %All to TestUser
ClassMethod GrantAll() As %Status
{
    Set sc = $$$OK
  
    &sql(GRANT %All To TestUser)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    Return sc
}

/// Disable Web terminal web application
ClassMethod DisableWT() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set App.Enabled=0
    Do App.%Save()

    Return sc
}

/// Enable Web terminal web application
ClassMethod EnableWT() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set App.Enabled=1
    Do App.%Save()

    Return sc
}

/// Unauthenticate Web terminal web application
ClassMethod Unauth() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set App.AutheEnabled=0
    Do App.%Save()

    Return sc
}

/// Authenticate Web terminal web application
ClassMethod Auth() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/terminal")
    Set App.AutheEnabled=32
    Do App.%Save()

    Return sc
}

}
