Class scw.Oauth Extends %CSP.Page
{

Parameter OAUTH2CLIENTREDIRECTURI = "/csp/user/scw.OauthRe.cls";

Parameter OAUTH2ROOT = "https://github.com/login/oauth/authorize";

Parameter OAUTH2APPNAME = "Data_APP_Security";

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
 <body style="text-align: center;">
	  <ul>
    <li><a href="/csp/sys/%25CSP.Portal.Home.zen">Management Portal</a></li>
    <li><a href="/terminal/">Web Terminal</a></li>
    <li><a href="/csp/user/index.csp">Main Tasks</a></li>
    <li><a href="/csp/user/scw.DataForm.cls">Data Form</a></li>
    <li><a href="/csp/user/scw.Login.cls">Login</a></li>
    <li><a href="/csp/user/scw.Oauth.cls">Login with Github account</a></li>
    </ul>
        <!-- insert the page content here -->
        <h1>GitHub OAuth2 API</h1>
        <p>This page demo shows how to call Github API functions using OAuth2 authorization.
        >
      
        
  // we need to supply openid scope to authenticate to Github
  //set scope="user"
  set scope="user"
  set properties("approval_prompt")="force"
  set properties("include_granted_scopes")="true"
  set url=##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(..#OAUTH2APPNAME,scope,
    ..#OAUTH2CLIENTREDIRECTURI,.properties,.isAuthorized,.sc) 
  w !,"<p><a href='"_url_"'>Github Sign In</a>" 


   &html<</body>
</html>>
  Quit $$$OK
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
  #dim %response as %CSP.Response
  set scope="user"
  if ##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#OAUTH2APPNAME,,scope,.accessToken,.idtoken,.responseProperties,.error) {
    set %response.ServerSideRedirect="/csp/user/scw.Oauth.cls"
  }
  quit 1
}

}
