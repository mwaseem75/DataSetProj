/// datasource from https://data.world/siyeh/synthetic-medical-data/workspace/project-summary?agentid=siyeh&datasetid=synthetic-medical-data
Class dc.data.medical.utility
{

ClassMethod importDS(id As %Integer)
{
    if $DATA(id) '= 1 {WRITE "Invalid Parameter" QUIT}
    SET ds = $CASE(id,1:"synthetic",2:"covid",3:"ood",4:"ps",5:"wdc",6:"hhcps",7:"bim",8:"brfv",:"Invalid")
    IF ds = "Invalid" { WRITE "Invalid Option"  QUIT  }    
    SET mDir = "/irisdev/app/src/data/"_ds
    SET mFileSpec = "*.csv"
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
   
    SET tSC=tRS.Execute(mDir,mFileSpec)

    WHILE tRS.Next() {
        SET filename=tRS.Get("Name")
        Kill classname
        kill coltype            
        //SET classname=$REPLACE("dc_data_synthetic."_tRS.Get("ItemName"),".csv","")
        SET classname=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        SET status=##class(dc.data.medical.utility).Process(filename,,.classname,.coltype,.tResults)	     
        //&sql( LOAD DATA FROM FILE %filename INTO %classname USING {"from":{"file":{"header":"1"}}})

          set qry = "LOAD DATA FROM FILE  '"_filename_"' INTO "_classname_ " "_"USING {""from"":{""file"":{""header"":""1""}}}"
            //set qry = "LOAD DATA FROM FILE %filename INTO %classname"
            w "query :"_qry,!
            SET myquery = qry 
            SET tStatement = ##class(%SQL.Statement).%New()
            SET qStatus = tStatement.%Prepare(myquery)
            IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
            SET rset = tStatement.%Execute()
            w qStatus
            RETURN "ok"
      }
}

ClassMethod Process(filenamecsv As %String, dlm As %String = ",", ByRef classname As %String, ByRef coltype As %String, Output recordsCount As %Integer, pverbose As %Boolean = 1, pappend As %Boolean = 0) As %Status
{
    set sc=$$$OK
    if $g(coltype)="" set coltype=..GetRowTypes(filenamecsv,dlm)
    set stc = ..CreateTbl(coltype,classname)
    q sc
}

ClassMethod GetRowTypes(filenamecsv As %String, dlm As %String = ",", deep As %Integer = 1) As %String
{
    set rowtypes=""
    set stream=..GetStreamFromFile(filenamecsv)      
        set header=stream.ReadLine() // Get Header columns
        //set filename = stream.filename
        set header=$ZCONVERT(header,"L")
        set dataLine=stream.ReadLine() // Read First line of data
        //set dataLine =..RemoveDlm(dataLine,dlm) // check it later

        //Read all the columns of header and add datatype against it        
        for i=1:1:($Length(header,dlm)) {
            kill types
            //Get datatype of the column
            do ##class(utility).GetDataType($Piece(dataLine,dlm,i),.types)
            set type=##class(utility).Decide(.types) 
            //Set 200 Varchar
            if type="VARCHAR" set type="VARCHAR(200)"
            set $Piece(rowtypes,dlm,i)=$TR($Piece(header,dlm,i)," ","")_" "_type
    }

    set rowtypes=$TR(rowtypes,dlm,",")
    // change "." symbol in column names
    set rowtypes=$TR(rowtypes,".","_")
    Return rowtypes
}

ClassMethod GetStreamFromFile(filename As %String) As %Stream
{
    set stream = ##Class(%Stream.FileCharacter).%New()
    set stream.LineTerminator = $Char(13,10)
    $$$TOE(sc,stream.LinkToFile(filename))
    //set filename = stream.FileName
    set abc="Test"
    //TBD check for sc
    return stream
}

ClassMethod CreateTbl(tblSql As %String, pp As %String) As %Status
{
 set sc=$$$OK
 set qry = "CREATE TABLE "_pp_" ("_tblSql_")"
 w "query :"_qry,!
 SET myquery = qry 
 SET tStatement = ##class(%SQL.Statement).%New()
 SET qStatus = tStatement.%Prepare(myquery)
 IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
 SET rset = tStatement.%Execute()
 return sc
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

ClassMethod HowManyRecords(classname As %String, ByRef recordsCount As %Integer) As %Status
{
   s tSC=$$$OK
   set table= ##class(%DeepSee.Utils).%GetSQLTableName(classname)
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

}
