/// datasource from https://data.world/siyeh/synthetic-medical-data/workspace/project-summary?agentid=siyeh&datasetid=synthetic-medical-data
Class dc.data.medical.Utility
{

ClassMethod Run() As %Status
{
	set fn="/irisdev/app/src/data/careplans.csv"
    kill pclass
    kill prowtype
  	set status=##class(dc.data.medical.Utility).Generate(fn,,.pclass,.prowtype,1,.tResults)
    set status=##class(dc.data.medical.Utility).Generate(fn,,.pclass,.prowtype,1,.tResults,,1)  
    return status
}

ClassMethod CreateTable()
{
   //Create Table Patient
   &sql(CREATE TABLE dc_data_health.Patients (
      patient CHAR(100) NULL,
      birthdate date NULL,
      deathdate date NULL,
      ssn CHAR(50) NULL,
      drivers CHAR(100) NULL,
      passport CHAR(100) NULL,
      prefix CHAR(100) NULL,
      firstn CHAR(100) NULL,
      lastn CHAR(100) NULL,
      suffix CHAR(100) NULL,
      maiden CHAR(100) NULL,
      marital CHAR(100) NULL,
      race CHAR(100) NULL,
      ethnicity CHAR(100) NULL,
      gender CHAR(1) NULL,
      birthplace CHAR(50) NULL,
      address CHAR(100) NULL
   ))
   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/patients.csv' INTO dc_data_health.Patients)
   }
   &sql(
      CREATE TABLE dc_data_health.Allergies (
      sratrdate CHAR(10) NULL,
      stopdate CHAR(10) NULL,
      patient CHAR(100) NULL,
      encounter CHAR(100) NULL,
      code NUMBER,
      description CHAR(100) NULL
   ))
   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
   } 
   &sql(
      CREATE TABLE dc_data_health.AllPrevalences (       
      Item CHAR(100) NULL,
      PopulationType CHAR(25) NULL,
      Occurrence NUMBER,
      PopulationCount NUMBER,
      PrevalenceRate DECIMAL(6,3),
      PrevalencePercentage DECIMAL(6,3)
      ))
   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/all_prevalences.csv' INTO dc_data_health.AllPrevalences USING {"from":{"file":{"header":"1"}}})
   }

   //TCODE,STARTDATE,STOPDATE,PATIENT,ENCOUNTER,CODE,DESCRIPTION,REASONCODE,REASONDESCRIPTION
   &sql(
      CREATE TABLE dc_data_health.Careplans (       
      Tcode CHAR(50) NULL,
      StartDate DATE NULL, 
      StopDate DATE NULL,
      Patient CHAR(50) NULL,
      Encounter CHAR(50) NULL,
      Code NUMBER NULL,
      Description CHAR(100) NULL,
      ReasonCode NUMBER,
      ReasonDescription CHAR(100)
      ))
   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/careplans.csv' INTO dc_data_health.Careplans USING {"from":{"file":{"header":"1"}}})
   }   
 //&sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
 //&sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
 //&sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
 //&sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
 //&sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
}

ClassMethod Generate(fncsv As %String, dlm As %String = ",", ByRef pclass As %String, ByRef prowtype As %String, pguessTypes As %Boolean = 1, Output recordsCount As %Integer, pverbose As %Boolean = 1, pappend As %Boolean = 0) As %Status
{
    set sc=$$$OK
    if $g(pclass)="" set pclass="community.csvgen.generated."_$TR($E(fncsv,1,5),":\/.","")_($zd($h,8))
    if $g(pappend),##class(%Dictionary.CompiledClass).%ExistsId(pclass) {
        ///ClassMethod Import(pSelectMode As %Library.Integer = {$zu(115,5)}, pFileName As %Library.String(MAXLEN=""), pDelimiter As %String = ",", pQuote As %String = """", pHeaders As %Integer = 0, ByRef pRecordCount As %Integer) As %Library.Integer [ SqlProc ]
        set pRecordCount=$CLASSMETHOD(pclass,"Import",,fncsv,dlm,,1,,pappend)
        }
    else {
        if $g(prowtype)="" set prowtype=..GetRowTypes(fncsv,dlm,pguessTypes)
        do ##class(%SQL.Util.Procedures).CSVTOCLASS(1, prowtype, fncsv, dlm, ,1, pclass)
        // change the generated method to add the Append support
        set sc=..AddAppendtoImport(pclass)
        if $$$ISERR(sc) q sc
    }
    If %sqlcontext.%SQLCODE && (%sqlcontext.%SQLCODE '= 100) Quit $$$ERROR($$$SQLCode, %sqlcontext.%SQLCODE, %sqlcontext.%Message)
    set sc=..HowManyRecords(pclass,.recordsCount)
    if $$$ISERR(sc) q sc
    if pverbose {
        Write !
        Write "Class name: "_pclass,!
        Write "Header: "_prowtype,!
        Write "Records imported: "_recordsCount
    }
    
    //ClassMethod Import(pSelectMode As %Library.Integer = {$zu(115,5)}, pFileName As %Library.String(MAXLEN=""), pDelimiter As %String = ",", pQuote As %String = """", pHeaders As %Integer = 0, ByRef pRecordCount As %Integer) As %Library.Integer [ SqlProc ]
    //if importData d $ClassMethod(pclass,"Import",1,fncsv,dlm,,1,.recordCount)
    q sc
}

ClassMethod GetRowTypes(fncsv As %String, dlm As %String = ",", guessTypes As %Boolean = 0, deep As %Integer = 1) As %String
{
    set rowtypes=""
    set stream=..GetStreamFromFile(fncsv)
    if 'guessTypes {
        set line=stream.ReadLine()

        for i=1:1:$Length(line,dlm) {
            set $Piece(rowtypes,dlm,i)=$TR($Piece(line,dlm,i)," ","")_" VARCHAR(250)"
        }
    }
    if guessTypes {
        set header=stream.ReadLine() // Get Header columns
        set filename = stream.filename
        set header=$ZCONVERT(header,"L")
        set dataLine=stream.ReadLine() // Read First line of data
        //set dataLine =..RemoveDlm(dataLine,dlm) // check it later

        //Read all the columns of header and add datatype against it        
        for i=1:1:($Length(header,dlm)) {
            kill types
            //Get datatype of the column
            do ##class(Utility).GetDataType($Piece(dataLine,dlm,i),.types)
            set type=##class(Utility).Decide(.types) 
            //Set 200 Varchar
            if type="VARCHAR" set type="VARCHAR(200)"
            set $Piece(rowtypes,dlm,i)=$TR($Piece(header,dlm,i)," ","")_" "_type

        }
    

    }

    set rowtypes=$TR(rowtypes,dlm,",")
    // change "." symbol in column names
    set rowtypes=$TR(rowtypes,".","_")
    Return rowtypes
}

ClassMethod GetStreamFromFile(fn As %String) As %Stream
{
    set stream = ##Class(%Stream.FileCharacter).%New()
    set stream.LineTerminator = $Char(13,10)
    $$$TOE(sc,stream.LinkToFile(fn))
    set filename = stream.FileName
    set abc="Test"
    //TBD check for sc
    return stream
}

ClassMethod IsDate(pVar As %String = "") As %Boolean
{
    set result=$$$YES
    Try {
        If $ZDateH(pVar,5)
    }
    Catch e {
        set result=$$$NO
    }

    Quit result
}

ClassMethod HowManyRecords(pclass As %String, ByRef recordsCount As %Integer) As %Status
{
   s tSC=$$$OK
   set table= ##class(%DeepSee.Utils).%GetSQLTableName(pclass)
   try {
    set st=##class(%SQL.Statement).%ExecDirect(,"SELECT COUNT(1) as ""result"" FROM "_table)
    if st.%SQLCODE < 0 throw ##class(%Exception.SQL).CreateFromSQLCODE(st.%SQLCODE,st.%Message)
    d st.%Next()
    set recordsCount=st."result"
   }
   Catch e {
       Set tSC = e.AsStatus()
   }

    q tSC
}

ClassMethod GetDataType(value As %String, ByRef types) As %Status
{
   if $IsvalidDouble(value) {
       if $I(types("DOUBLE"))
       if $L(value,".")>1,$L($P(value,".",2))<10 if $I(types("MONEY"))
       if ($L(value,".")=1) if $I(types("INTEGER"))
   quit $$$OK
   }
   if ..IsDate(value) {
       if $I(types("DATE")) 
       Quit $$$OK 
   }
   if $I(types("VARCHAR"))

   return $$$OK
}

ClassMethod Decide(ByRef types) As %String
{
    If $D(types("MONEY")),$D(types("DOUBLE")) {
        if types("MONEY")=types("DOUBLE") return "MONEY"
    }
    set i=$Order(types(""))
    while i'="" { 
        set typesI(types(i))=i
        set i=$Order(types(i))
    }
    if $D(typesI) return typesI($Order(typesI(""),-1))
    return "VARCHAR"
}

ClassMethod AddAppendtoImport(pClassName As %String) As %Status
{
 
    set method = ##class(%Dictionary.MethodDefinition).%OpenId(pClassName_"||Import")

    if method.FormalSpec["pAppend" quit $$$OK
    set method.FormalSpec=method.FormalSpec_",pAppend:%Boolean=0"
    set imp=method.Implementation
    set newImp=##class(%Stream.TmpCharacter).%New()

    while 'imp.AtEnd {
        set line=imp.ReadLine() 
        if line'["%DeleteExtent" {do newImp.WriteLine(line)}
        else {
            do newImp.WriteLine($p(line,"do")_"if 'pAppend do ..%DeleteExtent(,.tDeleted,.tInstances,1)")
        }
        }
    set method.Implementation=newImp
    set sc=method.%Save() 
    if $$$ISERR(sc) return sc
    set sc=$System.OBJ.Compile(pClassName,"cuk")
    return sc
}

}
