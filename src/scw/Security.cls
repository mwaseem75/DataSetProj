/// Class to deploy roles and users
Class scw.Security
{

/// Create users
ClassMethod CreateUsers() As %Status
{
    Set sc = $$$OK
    // 
    &sql(CREATE USER Test IDENTIFY BY demo)
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
    
    &sql(GRANT Reader To Test)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    
    &sql(GRANT Reader To UnknownUser)
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

    &sql(GRANT Writer To Test)
    if SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
    Return sc
}

}
