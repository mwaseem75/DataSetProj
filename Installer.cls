Include %occInclude

Class App.Installer
{

XData setup
{
<Manifest>
  <Default Name="NAMESPACE" Value="DATASETS"/>
  <Default Name="DBNAME" Value="DATASETS"/>
  <Default Name="APPPATH" Dir="/opt/irisapp/" />
  <Default Name="SOURCESPATH" Dir="${APPPATH}src" />
  <Default Name="CSPURL" Value="/csp/datasets" /> 
  <Default Name="RESOURCE" Value="%DB_${DBNAME}" /> 

  <Resource Name="%DB_${DBNAME}" Description="Medical Dataset Application" Permission="RW"/>

  <Namespace Name="${NAMESPACE}" Code="${DBNAME}" Data="${DBNAME}" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="${DBNAME}" Dir="${APPPATH}data" Create="yes" Resource="${RESOURCE}" MountAtStartup="true"/>
    </Configuration>
    <CSPApplication Url="${CSPURL}" Directory="${APPPATH}csp/" ServeFiles="1" Recurse="1" Grant="%DB_${NAMESPACE},%SQL" AuthenticationMethods="32" />
  </Namespace>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod SetAppProperties(pApp As %String, pPath As %String) As %Status
{
  New $Namespace
  Set $Namespace = "%SYS"

  Set tSC = ##class(Security.Applications).Get(pApp, .webProperties)

  If $$$ISERR(tSC) {
    Quit tSC
  }

  Set webProperties("Path") = pPath
  Set webProperties("Resource") = "" 
  Set webProperties("AutheEnabled") = 32 
  Set webProperties("AutoCompile") = 1 
  Set webProperties("ServeFiles") = 1 
  Set webProperties("iKnowEnabled") = 1 
  Set webProperties("DeepSeeEnabled") = 1 

  Set tSC = ##class(Security.Applications).Modify(pApp, .webProperties)

  Quit tSC
}

ClassMethod CompileCSP(pApp As %String, pNamespace As %String) As %Status
{
  New $Namespace
  Set $Namespace = pNamespace

  Set list(pApp_"/*.csp") = "" 
  Do $System.OBJ.CompileList(.list,"ck")

  Quit $$$OK
}

}
