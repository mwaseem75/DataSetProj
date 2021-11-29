/// Class to deploy roles and users
Class scw.Security
{

/// Create users
ClassMethod CreateUser() As %Status
{
    Set sc = $$$OK
    // 
    &sql(CREATE USER TestUser IDENTIFY BY demo)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    Return sc
}

/// Create Roles
ClassMethod CreateReaderRole() As %Status
{
    Set sc = $$$OK
    
    &sql(CREATE ROLE Reader)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    &sql(GRANT SELECT ON scw.Patient TO Reader)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    &sql(GRANT Reader To TestUser)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    Return sc
}

/// Description
ClassMethod CreateWriterRole() As %Status
{
    Set sc = $$$OK
    // do something
    &sql(CREATE ROLE Writer)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    &sql(GRANT UPDATE,INSERT ON scw.Patient TO writer)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)

    &sql(GRANT Writer To TestUser)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    Return sc
}

ClassMethod GrantAll() As %Status
{
    Set sc = $$$OK
  
    &sql(GRANT %All To TestUser)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    Return sc
}

ClassMethod DisableWT() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/Terminal")
    Set App.Enabled="0"
    Do App.%Save()

    Return sc
}

ClassMethod EnableWT() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/Terminal")
    Set App.Enabled="1"
    Do App.%Save()

    Return sc
}

ClassMethod Unauth() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/Terminal")
    Set App.PasswordAuthEnabled="0"
    Set App.UnauthenticatedEnabled="0"
    Do App.%Save()

    Return sc
}

ClassMethod Auth() As %Status
{
    Set sc = $$$OK
    New $Namespace
    Set $Namespace = "%SYS"
    Set App = ##class(Security.Applications).%OpenId("/Terminal")
    Set App.PasswordAuthEnabled="1"
    Set App.UnauthenticatedEnabled="1"
    Do App.%Save()

    Return sc
}

}
