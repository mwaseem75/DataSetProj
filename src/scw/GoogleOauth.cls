Class scw.GooleOauth Extends %CSP.Page
{

Parameter OAUTH2CLIENTREDIRECTURI = "/csp/user/scw.GoogleOauthRe.cls";

Parameter OAUTH2ROOT = "https://www.googleapis.com";

Parameter OAUTH2APPNAME = "Data_APP_Security";

ClassMethod OnPage() As %Status
{
  &html<<html>
<head>
</head>
<body style="text-align: center;">
        <!-- insert the page content here -->
        <h1>Google OAuth2 API</h1>
        <p>This page demo shows how to call Google API functions using OAuth2 authorization.
        <p>We are going to retrieve information about user and his/her Google Drive files as well as calendar entries.
        >
        
  // we need to supply openid scope to authenticate to Google
  //set scope="openid https://www.googleapis.com/auth/userinfo.profile"
  set scope="openid https://www.googleapis.com/auth/userinfo.profile"
  set properties("approval_prompt")="force"
  set properties("include_granted_scopes")="true"
  set url=##class(%SYS.OAuth2.Authorization).GetAuthorizationCodeEndpoint(..#OAUTH2APPNAME,scope,
    ..#OAUTH2CLIENTREDIRECTURI,.properties,.isAuthorized,.sc) 
  w !,"<p><a href='"_url_"'><img border='0' alt='Google Sign In' src='images/google-signin-button.png' ></a>" 
      &html<</body>
</html>>
  Quit $$$OK
}

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
  #dim %response as %CSP.Response
  set scope="openid https://www.googleapis.com/auth/userinfo.profile"
  if ##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#OAUTH2APPNAME,,scope,.accessToken,.idtoken,.responseProperties,.error) {
    set %response.ServerSideRedirect="Web.OAUTH2.Google2N.cls"
  }
  quit 1
}

}
