Class dc.data.medical.utility
{

ClassMethod ImportDS(id As %Integer, isWebCall As %Boolean = 0) As %String
{
       
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter"
        QUIT ""       
    }
    
        //if id = 999 then install all the files by looping through all 12 folders
    IF id = 999 
    {SET start=1,end=12}
    ELSE
    {SET start = id, end = id}

    FOR counter=start:1:end
    {
    // Get directory name based on parameter value
    Set ds = ..GetDSName(counter)
  
      // Check if valid value is entered
    IF ds = "Invalid" 
    { 
        WRITE "Invalid Option! Valid options are between 1 to 12"  
        RETURN ""      
    }   
    
    //Get Directory Name
    SET mDir = "/irisdev/app/src/data/"_ds
    //SET mDir = "/usr/irissys/lib/data/"_ds
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    DO tRS.Execute(mDir,mFileSpec)
    //WRITE "SQL CODE VALUE"_tSC.%SQLCODE
    //Initate return value for web application
    SET returnVal = ""
    IF isWebCall { SET returnVal = "DATASET : "_ds_" Installation Status"_$c(10)_$c(13) }
    ELSE {WRITE "DATASET : "_ds,! }
    //Get all the files from directory 
    WHILE tRS.Next() {
        //Get file name
        SET filename=tRS.Get("Name")
        //Remove .csv from the file name
        SET tableName=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        //Get columns based on the header row of csv file
        Do ..GetColTypes(filename,.coltype)	     
        
        //Dynamically create table based on tablename and column types
        SET qry = "CREATE TABLE "_tableName_" ("_coltype_")"
        SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
        
        //Check if table created successfully
        IF rset.%SQLCODE
        {
             WRITE rset.%Message,!          
        }
        ELSE
        {
            //Dynamically construct LOAD DATA statement
            SET qry = "LOAD DATA FROM FILE  '"_filename_"' INTO "_tableName_ " "_"USING {""from"":{""file"":{""header"":""1""}}}"
            SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
            IF rset.%SQLCODE
            {
                IF isWebCall {SET returnVal = returnVal _ "ERROR Table : " _tableName_" IMPORT FAILED: "_rset.%Message_$c(10)_$c(13)}
                ELSE {   WRITE "ERROR Table : " _tableName_" IMPORT FAILED: ",rset.%Message,!}
            } 
            ELSE
            
            {
                //Check %SQL_Diag.Result table
                 SET qry = "SELECT id,errorcount FROM %SQL_Diag.Result WHERE ID = (SELECT MAX(ID) FROM %SQL_Diag.Result )"
                 SET tStatement = ##class(%SQL.Statement).%New()
                 SET qStatus = tStatement.%Prepare(.qry)
                 IF qStatus =1 {
                     SET rsetD = tStatement.%Execute()
                     //DO rset.%Display()
                    WHILE rsetD.%Next() {
                        SET diagID = rsetD.%GetData(1)
                        SET errors = rsetD.%GetData(2)                        
                        }
                 }
                IF errors > 0 { 
                    IF isWebCall {SET returnVal = returnVal _ "Table : "_tableName_", "_" LoadedRows="_rset.%ROWCOUNT_" DiagID="_diagID_"  Errors="_errors_$c(10)_$c(13)}
                    ELSE {WRITE "Table : "_tableName_",", ?45," LoadedRows="_rset.%ROWCOUNT_"", ?65," DiagID="_diagID, "  Errors="_errors,!}
                }
                ELSE
                {
                   IF isWebCall {SET returnVal = returnVal _ "Table : "_tableName_", "_" LoadedRows="_rset.%ROWCOUNT_" DiagID="_diagID_$c(10)_$c(13)}
                   ELSE {WRITE "Table : "_tableName_",", ?45," LoadedRows="_rset.%ROWCOUNT_"", ?65," DiagID="_diagID,!} 
                }    
            }
        }   
    }
   }
   return returnVal
}

// Get column lists based on the Header Row of CSV File

ClassMethod GetColTypes(filenamecsv As %String, ByRef coltype As %String, dlm As %String = ",")
{
    SET coltype=""
    SET stream=..GetStreamFromFile(filenamecsv)      
    SET header=stream.ReadLine() // Get Header columns
    SET header=$ZCONVERT(header,"L")
    SET dataLine=stream.ReadLine() // Read First line of data
        
    //Read all the columns of header and add datatype against it        
    FOR i=1:1:($Length(header,dlm)) {
        kill types
        //Get datatype of the column
        DO ..GetDataType($Piece(dataLine,dlm,i),.types)
        SET type=..GetType(.types) 

        // if type is varchar then assign length 250
        IF type="VARCHAR" SET type="VARCHAR(250)"
        SET $Piece(coltype,dlm,i)=$TR($Piece(header,dlm,i)," ","")_" "_type
    }
    SET coltype=$TR(coltype,dlm,",")
    // change "." symbol in column names
    SET coltype=$TR(coltype,".","_")
}

// Open CSV File to read

ClassMethod GetStreamFromFile(filename As %String) As %Stream
{
    // create new stream and link to the file
    SET stream = ##Class(%Stream.FileCharacter).%New()
    SET stream.LineTerminator = $Char(13,10)
    $$$TOE(sc,stream.LinkToFile(filename))
    RETURN stream
}

// Check if the data is valid date in order to figure out column data type

ClassMethod IsDate(pVar As %String = "") As %Boolean
{
    SET sts=$$$YES
    Try {
        If $ZDateH(pVar,5)
    }
    Catch e {
        SET sts=$$$NO
    }
    Quit sts
}

// Get column data type based on the first record in CSV file

ClassMethod GetDataType(value As %String, ByRef types) As %Status
{
  
   //Get datatype based on the first column value 
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

// Get data type based on the each column of first row after header row

ClassMethod GetType(ByRef types) As %String
{
    If $D(types("MONEY")),$D(types("DOUBLE")) {
        if types("MONEY")=types("DOUBLE") return "MONEY"
    }
    SET i=$Order(types(""))
    while i'="" { 
        SET typesI(types(i))=i
        SET i=$Order(types(i))
    }
    if $D(typesI) return typesI($Order(typesI(""),-1))
    return "VARCHAR"
}

/// Get the folder against the dataset ID
ClassMethod GetDSName(counter As %Integer) As %Status
{
    SET ds = $CASE(counter,1:"synthetic",2:"hcanalytics",3:"globalsuicide",4:"covidpolls",5:"cancerrates",6:"overdosedeaths",
                           7:"hdprediction",8:"medicalservices",9:"hospitalratings",10:"hfprediction",11:"diabetes",12:"kidneydisease",
                            :"Invalid")
    RETURN ds
}

// Function to Remove particular Dataset

ClassMethod RemoveDS(id As %Integer, isWebCall As %Boolean = 0) As %String
{
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter" 
        QUIT ""
    }
    //Init variable
    set returnVal=""
    //if id = 999 then run loop through all 12 folders
    IF id = 999 
    {SET start=1,end=12}
    ELSE
    {SET start = id, end = id}
    
    FOR counter=start:1:end
    {
    // Get directory name based on parameter value
    Set ds = ..GetDSName(counter)
    
    // Check if valid value is entered
    IF ds = "Invalid" 
    { 
        WRITE "Invalid Option! Valid options are between 1 to 12"  
        RETURN "" 
    }    
    
    //Get Directory Name
    SET mDir = "/irisdev/app/src/data/"_ds
    //SET mDir = "/usr/irissys/lib/data/"_ds
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    DO tRS.Execute(mDir,mFileSpec)
   
    IF isWebCall { SET returnVal = "DATASET : "_ds_$c(10)_$c(13) }
    ELSE {WRITE "DATASET : "_ds,! }
    
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET tableName=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        //Drop table 
        SET qry = "DROP TABLE "_tableName
        SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
      
        //Check if table deleted successfully
        IF rset.%SQLCODE
        {
             IF isWebCall { SET returnVal = returnVal_ "ERROR : "_rset.%Message_$c(13) }
             ELSE {WRITE "ERROR : ",rset.%Message,!          }
        } 
        ELSE
        {
            IF isWebCall { SET returnVal = returnVal_"Table "_tableName_" Deleted Successfully"_$c(13) }
            ELSE {WRITE "Table "_tableName_" Deleted Successfully",! }
        }
      }
   }
   RETURN returnVal
}

// Function to check if particular dataset is imported or not 

ClassMethod GetStatusDS(id As %Integer)
{
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter" 
        QUIT
    }
    //ZN "DATASETS"
    //if id = 999 then run loop through all 12 folders
    IF id = 999 
    {SET start=1,end=12}
    ELSE
    {SET start = id, end = id}
    
    FOR counter=start:1:end
    {
    // Get directory name based on parameter value
    Set ds = ..GetDSName(counter)
    
    // Check if valid value is entered
    IF ds = "Invalid" 
    { 
        WRITE "Invalid Option! Valid options are between 1 to 12"  
        QUIT  
    }    
    
    //Get Directory Name
    SET mDir = "/irisdev/app/src/data/"_ds
    //SET mDir = "/usr/irissys/lib/data/"_ds
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    DO tRS.Execute(mDir,mFileSpec)
    
    WRITE "DATASET : "_ds,! 
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET tableName=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        //Get table Status 
        SET sts = $SYSTEM.SQL.Schema.TableExists(tableName) 
        
        //Check if table deleted successfully
        IF sts = 1
        {
             WRITE "Table "_tableName_" Exists",!       
        } 
        ELSE
        {
            WRITE "Table "_tableName_" not Exists",!
        }
      }
   }
}

// Get status of all datasets

ClassMethod ListDS()
{
    
    WRITE "LIST OF DATASETS",! 
    WRITE "ID", ?3,"NAME ", ?20,"SOURCE ",?35,"LICENCE", ?53, "STATUS ",!
    WRITE "-------------------------------------------------------------",!
    // Check the status of all 12 datasets
    FOR counter=1:1:12
    {
    // Get directory name based on parameter value
    
    SET ds = ..GetDSName(counter)
    SET dsSrc = $CASE(counter,4:"data.world",4:"data.world",5:"data.world",
                              6:"data.world",7:"data.world", 8:"data.world",10:"data.world",:"kaggle.com")
    SET dsLic = $CASE(counter,4:"CC-BY",10:"CC BY 4.0",:"Public Domain")                          
    // Check if valid value is entered
    IF ds = "Invalid" 
    { 
        WRITE "Invalid Option! Valid options are between 1 to 12"  
        QUIT  
    }    
    
    //Get Directory Name
    SET mDir = "/irisdev/app/src/data/"_ds
    //SET mDir = "/usr/irissys/lib/data/"_ds
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    DO tRS.Execute(mDir,mFileSpec)
    
    
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET tableName=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        //Get table Status 
        SET sts = $SYSTEM.SQL.Schema.TableExists(tableName) 
        
        //Check if table deleted successfully
        set insSts = "Not Installed"
        IF sts = 1 set insSts = "Installed"
        WRITE counter, ?3,ds, ?20,dsSrc, ?35, dsLic,?53,insSts,!     
        //Run only once.
        QUIT
      }
   }
}

// Used in web allication to get DataSet table name based on the ID

ClassMethod GetDSTableName(id As %Integer) As %String
{
    SET ds = $CASE(id,111:"dc_data_synthetic.all_prevalences",
                      112:"dc_data_synthetic.allergies",
                      113:"dc_data_synthetic.careplans",
                      114:"dc_data_synthetic.claims",
                      115:"dc_data_synthetic.conditions",
                      116:"dc_data_synthetic.encounters",
                      117:"dc_data_synthetic.immunizations",
                      118:"dc_data_synthetic.medications",
                      119:"dc_data_synthetic.observations",
                      120:"dc_data_synthetic.patients",
                      121:"dc_data_synthetic.procedures",
                      211:"dc_data_hcanalytics.AV_First_Health_Camp_Attended",
                      212:"dc_data_hcanalytics.AV_Health_Camp_Detail",
                      213:"dc_data_hcanalytics.AV_Patient_Profile",
                      214:"dc_data_hcanalytics.AV_sample_submmission",
                      215:"dc_data_hcanalytics.AV_Second_Health_Camp_Attended",
                      216:"dc_data_hcanalytics.AV_Test",
                      217:"dc_data_hcanalytics.AV_Third_Health_Camp_Attended",
                      218:"dc_data_hcanalytics.AV_Train",    
                      311:"dc_data_globalsuicide.gender_rates",
                      312:"dc_data_globalsuicide.Male_Female_Ratio_of_Suicide_Rates",
                      313:"dc_data_globalsuicide.MH_12",
                      314:"dc_data_globalsuicide.SDGSUICIDE",
                      315:"dc_data_globalsuicide.suicide_by_age",
                      316:"dc_data_globalsuicide.suicide_death_rates",
                      317 :"dc_data_globalsuicide.suicide_rates_by_country",    
                      411 :"dc_data_covidpolls.covid_approval_polls_adjusted",
                      412 :"dc_data_covidpolls.covid_approval_polls",
                      413 :"dc_data_covidpolls.covid_approval_toplines",
                      414 :"dc_data_covidpolls.covid_concern_polls_adjusted",
                      415 :"dc_data_covidpolls.covid_concern_polls",
                      416 :"dc_data_covidpolls.covid_concern_toplines",
                      417 :"dc_data_covidpolls.data_dictionary_covid19_polls",  
                      511 :"dc_data_cancerrates.uscs_map_death_all",
                      512 :"dc_data_cancerrates.uscs_map_incidence_all",  
                      611 :"dc_data_overdosedeaths.Multiple_Cause_of_Death_1999_2014",
                      612 :"dc_data_overdosedeaths.Multiple_Cause_of_Death_1999_2014_v1", 
                      711 :"dc_data_hdprediction.Heart_Disease_Prediction", 
                      811 :"dc_data_medicalservices.medical_services",
                      911 :"dc_data_hospitalratings.Hospital_General_Information",
                      1011 :"dc_data_hfprediction.heart_failure_clinical_records_dataset",
                      1111 :"dc_data_diabetes.Diabetes_Dataset",
                      1211 :"dc_data_kidneydisease.new_model",
                      :"Invalid")
    RETURN ds
}

// Function get DataSet Name to be used in datatable Header

ClassMethod GetDSTitleName(id As %Integer) As %String
{
    set dsName = ""
    if ((id>=111)&&(id<=121)){SET dsName = "Synthetic Medical Data"}
    if ((id>=211)&&(id<=218)){SET dsName = "Health Care Analytics - 1"}
    if ((id>=311)&&(id<=317)){SET dsName = "Global Suicide Data"}
    if ((id>=411)&&(id<=417)){SET dsName = "COVID-19 Polls"}
    if ((id>=511)&&(id<=512)){SET dsName = "Cancer Rates by U.S. State"}
    if ((id>=611)&&(id<=612)){SET dsName = "Opioid Overdose Deaths"}
    if (id=711){SET dsName = "Yellowpages medical services dataset"}
    if (id=811){SET dsName = "Heart Disease Prediction"}
    if (id=911){SET dsName = "Hospital ratings"}
    if (id=1011){SET dsName = "Heart Failure Prediction"}
    if (id=1111){SET dsName = "Diabetes Dataset"}
    if (id=1211){SET dsName = "Chronic Kidney Disease"}

    RETURN dsName
}

// Function get tables columns based on the table ID to be used in datatable Header Row

ClassMethod GetDSColNamesTH(id As %Integer) As %String
{
    set tblName = ..GetDSTableName(id)
    set myquery = "SELECT * FROM "_tblName
    SET tStatement = ##class(%SQL.Statement).%New(0)
    SET tStatement.%ObjectSelectMode=1
    SET qStatus = tStatement.%Prepare(myquery)
    //IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    IF qStatus'=1 {RETURN ""}
    SET rset = tStatement.%Execute()
    IF rset.%SQLCODE=0 {
        SET rsmeta=rset.%GetMetadata()
        SET x=rsmeta.columns.Count()
        SET dtbl = ""
        SET x=1
         WHILE rsmeta.columns.GetAt(x) {
            SET column=rsmeta.columns.GetAt(x)
            SET dt = column.colName
            SET dtbl = dtbl_"<th>"_dt_"</th>"
            SET x=x+1 }           
     }
     ELSE { 
         WRITE !,"SQLCODE=",rset.%SQLCODE," ",rset.%Message 
         return ""}
     return dtbl
}

// Function get tables rows daynamically to be used in datatable

ClassMethod GetDSRows(id As %Integer) As %String
{
  SET tblName = ..GetDSTableName(id)
  SET myquery = "SELECT * FROM "_tblName
  SET tStatement = ##class(%SQL.Statement).%New(0)
  SET tStatement.%ObjectSelectMode=1
  SET qStatus = tStatement.%Prepare(myquery)
  //IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
  IF qStatus'=1 {RETURN ""}
  SET rset = tStatement.%Execute()
  ///////////////////////
  IF rset.%SQLCODE=0 {
  SET rsmeta=rset.%GetMetadata()
  SET x=rsmeta.columns.Count()
  SET dtbl = ""
  // Main loop
  WHILE rset.%Next() {
        SET x=1
        set dtbl = dtbl_"<tr>"
        // Inner loop for columns
        WHILE rsmeta.columns.GetAt(x) {
            SET column=rsmeta.columns.GetAt(x)
            SET dt = rset.%GetData(x)
            if column.ODBCType = 9 { set dt = $ZDATE(dt,3)}
            set dtbl = dtbl_"<td>"_dt_"</td>"
            SET x=x+1 }
            set dtbl = dtbl_"</tr>"          
    }
  }
  ELSE {
       WRITE !,"SQLCODE=",rset.%SQLCODE," ",rset.%Message 
       RETURN ""}
  RETURN dtbl
}

// Function used in web application to get Table total records based on the ID

ClassMethod GetTotalRecords(id As %Integer) As %String
{
  SET tblName = ..GetDSTableName(id)
  if tblName = "Invalid" {RETURN ""}
  SET qry = "SELECT COUNT(*) As total FROM "_tblName
  SET tStatement = ##class(%SQL.Statement).%New()
  SET qStatus = tStatement.%Prepare(.qry)
  IF qStatus'=1 {RETURN ""}
  SET rset = tStatement.%Execute()
  //DO rset.%Display()
  WHILE rset.%Next() {
    RETURN rset.%GetData(1)
    }
  RETURN ""
}

// Install 1 dataset by defualt

ClassMethod InitDS()
{
    SET tableName(1) = "dc_data_synthetic.all_prevalences"
    SET tableName(2) = "dc_data_synthetic.allergies"
    SET tableName(3) = "dc_data_synthetic.careplans"
    SET tableName(4) = "dc_data_synthetic.claims"
    SET tableName(5) = "dc_data_synthetic.conditions"
    SET tableName(6) = "dc_data_synthetic.encounters"
    SET tableName(7) = "dc_data_synthetic.immunizations"
    SET tableName(8) = "dc_data_synthetic.medications"
    SET tableName(9) = "dc_data_synthetic.observations"
    SET tableName(10) = "dc_data_synthetic.patients"
    SET tableName(11) = "dc_data_synthetic.procedures"
    SET fileName(1) = "/irisdev/app/src/data/synthetic/all_prevalences.csv"
    SET fileName(2) = "/irisdev/app/src/data/synthetic/allergies.csv"
    SET fileName(3) = "/irisdev/app/src/data/synthetic/careplans.csv"
    SET fileName(4) = "/irisdev/app/src/data/synthetic/claims.csv"
    SET fileName(5) = "/irisdev/app/src/data/synthetic/conditions.csv"
    SET fileName(6) = "/irisdev/app/src/data/synthetic/encounters.csv"
    SET fileName(7) = "/irisdev/app/src/data/synthetic/immunizations.csv"
    SET fileName(8) = "/irisdev/app/src/data/synthetic/medications.csv"
    SET fileName(9) = "/irisdev/app/src/data/synthetic/observations.csv"
    SET fileName(10) = "/irisdev/app/src/data/synthetic/patients.csv"
    SET fileName(11) = "/irisdev/app/src/data/synthetic/procedures.csv"    
 
        FOR i=1:1:11
        {
        do ..InitDSDtl(tableName(i),fileName(i))
        }
}

ClassMethod InitDSDtl(tableName As %String, fileName As %String)
{
    //ZN "DATASETS"
  
    Do ..GetColTypes(fileName,.coltype)	     
      //Dynamically create table based on tablename and column types
    SET qry = "CREATE TABLE "_tableName_" ("_coltype_")"
    SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
        //Check if table created successfully
        IF rset.%SQLCODE
        {
             WRITE "ERROR : ",rset.%Message,!          
        }
        ELSE
        {
            //Dynamically construct LOAD DATA statement
            SET qry = "LOAD DATA FROM FILE  '"_fileName_"' INTO "_tableName_ " "_"USING {""from"":{""file"":{""header"":""1""}}}"
            SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
            IF rset.%SQLCODE
            {
                WRITE "ERROR Table : " _tableName_" IMPORT FAILED: ",rset.%Message,!
            } 
            ELSE
            {
                 //Check %SQL_Diag.Result table
                 SET qry = "SELECT id,errorcount FROM %SQL_Diag.Result WHERE ID = (SELECT MAX(ID) FROM %SQL_Diag.Result )"
                 SET tStatement = ##class(%SQL.Statement).%New()
                 SET qStatus = tStatement.%Prepare(.qry)
                 IF qStatus =1 {
                     SET rsetD = tStatement.%Execute()
                     //DO rset.%Display()
                    WHILE rsetD.%Next() {
                        SET diagID = rsetD.%GetData(1)
                        SET errors = rsetD.%GetData(2)                      
                    }
                 }
                WRITE "Table : "_tableName_",", ?45," LoadedRows="_rset.%ROWCOUNT_"", ?65," ErrorCount="_errors_"", ?85," DiagID="_diagID,!
            }
        }
}

}
