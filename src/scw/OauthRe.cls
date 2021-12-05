Include %occInclude

Class scw.OauthRe Extends %CSP.Page
{

Parameter OAUTH2APPNAME = "Data_APP_Security";

Parameter OAUTH2ROOT = "https://github.com/login/oauth/authorize";

ClassMethod OnPage() As %Status
{
  &html<<html>
   <head>
   </head>
   <STYLE>
body { font-family: arial; }

     table.tpTable caption{
       background: transparent;
       font-size: 1.4em;
       font-weight: bold;
       text-align: left;
       border: none;
     }
  
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background-color: #2b3589;
}

li {
  float: left;
}

li a {
  display: block;
  color: white;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 1em;
}

/* Change the link color to #111 (black) on hover */
li a:hover {
  background-color: #111;
}


/* vertical menu */
#ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  width: 300px;
  background-color: #f1f1f1;
  border: 1px solid #555;
}
#li a {
  display: block;
  color: #000;
  padding: 8px 16px;
  text-decoration: none;
  font-size: large;
  width: 270px;

}

#li {
  text-align: center;
  border-bottom: 1px solid #555;
}

#li:last-child {
  border-bottom: none;
}

#li a:hover:not(.active) {
  background-color: #04AA6D;
  color: white;
}

.container { 
  top: 300px;
  border: 3px solid green; 
}

.center {
  
  position: absolute;
  left: 20%;
  
}

</STYLE>
   <body>
   <ul>
    <li><a href="/csp/sys/%25CSP.Portal.Home.zen">Management Portal</a></li>
    <li><a href="/terminal/">Web Terminal</a></li>
    <li><a href="/csp/user/index.csp">Main Tasks</a></li>
    <li><a href="/csp/user/scw.DataForm.cls">Data Form</a></li>
    <li><a href="/csp/user/scw.Login.cls">Login</a></li>
    <li><a href="/csp/user/scw.Oauth.cls">Login with Github account</a></li>
    </ul>>
  // Check if we have an access token
  // to see if token has already been saved locally 
 set scope="user"
 set redirect="Oauth.cls"
 
 do ##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint("Data_APP_Security",
       scope,redirect,.properties,.isAuthorized,.sc)
 if $$$ISERR(sc) {
   //error handling here
   w "<h1>Error while Authorization with Github!</h1>"
 }
  else
  {
   w "<h1>Successfully Authorize in IRIS via Github OAuth2</h1>"
 }
  &html<</body>
  </html>>
  Quit $$$OK
}

}
