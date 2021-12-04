Include %occInclude

Class scw.GooleOauthRe Extends %CSP.Page
{

Parameter OAUTH2APPNAME = "Data_APP_Security";

Parameter OAUTH2ROOT = "https://www.googleapis.com";

ClassMethod OnPage() As %Status
{
  &html<<html>
   <head>
   </head>
   <body>>
  // Check if we have an access token
  set scope="openid https://www.googleapis.com/auth/userinfo.profile"
  
  set isAuthorized=##class(%SYS.OAuth2.AccessToken).IsAuthorized(..#OAUTH2APPNAME,,scope,.accessToken,.idtoken,.responseProperties,.error)
   &html<<h1>> w accessToken &html<</h1>>

  if isAuthorized { 
    // Google has no introspection endpoint - nothing to call - the introspection endpoint and display result -- see RFC 7662.  
    w "<h3>Data from <span style='color:red;'>GetUserInfo API</span></h3>"
    // userinfo has special API, but could be also retrieved by just calling Get() method with appropriate url    
    try {
	   
    set tHttpRequest=##class(%Net.HttpRequest).%New()
      $$$THROWONERROR(sc,##class(%SYS.OAuth2.AccessToken).AddAccessToken(tHttpRequest,"query","GOOGLE",..#OAUTH2APPNAME))
      //$$$THROWONERROR(sc,##class(%SYS.OAuth2.AccessToken).GetUserinfo(..#OAUTH2APPNAME,accessToken,,.jsonObject))
      w jsonObject.%ToJSON()
    } catch (e) {
      w "<h3><span style='color: red;'>ERROR: ",$zcvt(e.DisplayString(),"O","HTML")_"</span></h3>"    
    }
    /******************************************
    *                                         *
    *      Retrieve info from other APIs      *
    *                                         *
    ******************************************/
    w "<hr>"
    ///do ..RetrieveAPIInfo("/drive/v3/files")
 
    ///do ..RetrieveAPIInfo("/calendar/v3/users/me/calendarList")
  } else {
    w "<h1>Not authorized!</h1>"  
  }
  &html<</body>
  </html>>
  Quit $$$OK
}

ClassMethod RetrieveAPIInfo(api As %String)
{
  w "<h3>Data from <span style='color:red;'>"_api_"</span></h3><p>"
  try {
    set tHttpRequest=##class(%Net.HttpRequest).%New()
    $$$THROWONERROR(sc,##class(%SYS.OAuth2.AccessToken).AddAccessToken(tHttpRequest,"query","GOOGLE",..#OAUTH2APPNAME))
    $$$THROWONERROR(sc,tHttpRequest.Get(..#OAUTH2ROOT_api))
    set tHttpResponse=tHttpRequest.HttpResponse
    s tJSONString=tHttpResponse.Data.Read()
    if $e(tJSONString)'="{" {
      // not a JSON
      d tHttpResponse.OutputToDevice()
    } else {      
      w tJSONString
      w "<hr/>"
      /*
      // new JSON API
      &html<<table border=1 style='border-collapse: collapse'>>
      s tJSONObject={}.%FromJSON(tJSONString)
      set iterator=tJSONObject.%GetIterator()
        while iterator.%GetNext(.key,.value) {
          if $isobject(value) {
            set iterator1=value.%GetIterator()
            w "<tr><td>",key,"</td><td><table border=1 style='border-collapse: collapse'>"
            while iterator1.%GetNext(.key1,.value1) {
            if $isobject(value1) {
                set iterator2=value1.%GetIterator()
                w "<tr><td>",key1,"</td><td><table border=0 style='border-collapse: collapse'>"
                while iterator2.%GetNext(.key2,.value2) {
                    write !, "<tr><td>",key2, "</td><td>",value2,"</td></tr>"                   
                }
                // this way we can go on and on into the embedded objects/arrays
              w "</table></td></tr>"
            } else {
                  write !, "<tr><td>",key1, "</td><td>",value1,"</td></tr>"       
            }
            }
          w "</table></td></tr>"
          } else {
              write !, "<tr><td>",key, "</td><td>",value,"</td></tr>"
          }
        }       
    &html<</table><hr/>
    >
    */
    }
  } catch (e) {
    w "<h3><span style='color: red;'>ERROR: ",$zcvt(e.DisplayString(),"O","HTML")_"</span></h3>"
  }
}

}
