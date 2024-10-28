Class FHIRDEMO.Install Extends %RegisteredObject
{

    ClassMethod Run() As %Status{
        

         Set namespace = "FHIRDEMO"
    Set databaseDir = "/irisdata/mgr/"
    Set productionName = "FHIRDEMOPKG.FoundationProduction"
    set networkName = "localhost"

    /// Define a property array for custom variables
    Set pVars("DBInstallDirectory") = databaseDir
    Set pVars("HOSTNAME")=networkName
    Set pVars("Component")=networkName_":"_namespace


      Set sc = $$$OK


    Return sc
    }

    /// an example of Installer class just to create a new clear namespace and database IRISAPP


XData setup
{
<Manifest>
  <Default Name="Namespace" Value="FHIRDEMO"/>
  <Default Name="database" Value="fhirdemo"/>
  
  <Namespace Name="${Namespace}" Code="${Namespace}-CODE" Data="${Namespace}-DATA" Create="yes" Ensemble="1">
    <Configuration>
      <Database Name="${Namespace}-DATA" Dir="${mgrdir}${database}/data" Create="yes" Resource="%DB_${Namespace}-DATA"/>
      <Database Name="${Namespace}-CODE" Dir="${mgrdir}${database}/code" Create="yes" Resource="%DB_${Namespace}-CODE"/>
    </Configuration>
     <CSPApplication Url="/csp/${app}" Directory="${cspdir}${app}"  ServeFiles="1" Recurse="1" MatchRoles=":%DB_${Namespace}" AuthenticationMethods="32" 
    />
  </Namespace>
</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
  #; Let XGL document generate code for this method. 
  Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

}
