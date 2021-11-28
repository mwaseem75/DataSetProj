/// Login Page
Class scw.Login Extends %ZEN.Component.page
{

/// Class name of application this page belongs to.
Parameter APPLICATION;

/// Displayed name of this page.
Parameter PAGENAME;

/// Domain used for localization.
Parameter DOMAIN;

ClassMethod DrawHTML(pSeed As %String) As %Status
{
    &html<<br>>
    &html<<h1>User : #($UserName)#<h1>>
    &html<<h1>Roles : #($ROLES)#<h1>>
    
    &html<<ul>>
    &html<<li><a href="http://127.0.0.1:52773/csp/sys/%25CSP.Portal.Home.zen?IRISLogout=end">Management Portal</a></li>>
    &html<<li><a href="http://localhost:52773/terminal/">Web Terminal</a></li>>
    &html<<li><a href="http://localhost:52773/csp/user/list.csp">Main Tasks</a></li>>
    &html<<li><a href="http://localhost:52773/csp/user/scw.DataForm.cls">Data Form</a></li>>
    &html<<li><a href="http://localhost:52773/csp/user/scw.Login.cls">Login</a></li>>
    &html<</ul>>

    Quit $$$OK
}

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
    /*Style classes for use on this page */
   
     body { font-family: arial; }

     table.tpTable caption{
       background: transparent;
       font-size: 1.4em;
       font-weight: bold;
       text-align: left;
       border: none;
     }

    /* even rows */
     .tpEven { color: black; background: #ebf3ff; }
    
    /* odd rows */
     .tpOdd { color: black; background: white; }

    /* this is a selected row */
     table.tpTable tr.tpSelected { background: #3d80df; color: white; }
   
    /* hover for odd and even rows */
     tr.tpOdd:hover,tr.tpEven:hover { 
        background-color: #3d80df; 
        color: #ffffff; }
  
    /* table header style */
    table.tpTable th {
        border-right: 1px solid gray;
        border-bottom: 1px solid gray;
        background: #C5D6D6;
        color: black;
        font-weight: bold;
        text-align: left;
        padding: 2px;
        overflow: hidden;
     }

    /* selected column header (th) */
     table.tpTable th.tpHdrSelected { background: #3d80df; }

    /* filter layout */
     table.tpFilterLayout td { border: none; background: #C5D6D6; }
  </style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<html align="center"><h2>Login Page</h2></html>
<loginForm align="center" cellStyle="padding:5px;" id="form"> 
<text label="User:" name="CacheUserName" /> 
<password label="Pwd:" name="CachePassword" /> <submit caption="Login"/> 
</loginForm> 
<html OnDrawContent="DrawHTML"></html>
</page>
}

}
