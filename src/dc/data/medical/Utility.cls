/// datasource from https://data.world/siyeh/synthetic-medical-data/workspace/project-summary?agentid=siyeh&datasetid=synthetic-medical-data
Class dc.data.medical.utility
{

ClassMethod ImportDS(id As %Integer)
{
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter" 
        QUIT
    }
    
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
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    SET tSC=tRS.Execute(mDir,mFileSpec)
    WRITE "DATASET : "_ds,! 
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET filename=tRS.Get("Name")
        SET tableName=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        Do ##class(dc.data.medical.utility).GetColTypes(filename,.coltype)	     
        
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
            SET qry = "LOAD DATA FROM FILE  '"_filename_"' INTO "_tableName_ " "_"USING {""from"":{""file"":{""header"":""1""}}}"
            SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
            IF rset.%SQLCODE
            {
                WRITE "ERROR Table : " _tableName_" IMPORT FAILED: ",rset.%Message,!
            } 
            ELSE
            {
                WRITE "SUCCESS table : " _tableName_" created and "_rset.%ROWCOUNT_" Rows Imported Successfully",!
            }
        }   
    }
   }
}

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
        DO ##class(utility).GetDataType($Piece(dataLine,dlm,i),.types)
        SET type=##class(utility).GetType(.types) 

        // if type is varchar then assign length 200
        IF type="VARCHAR" SET type="VARCHAR(200)"
        SET $Piece(coltype,dlm,i)=$TR($Piece(header,dlm,i)," ","")_" "_type
    }
    SET coltype=$TR(coltype,dlm,",")
    // change "." symbol in column names
    SET coltype=$TR(coltype,".","_")
}

ClassMethod GetStreamFromFile(filename As %String) As %Stream
{
    // create new stream and link to the file
    SET stream = ##Class(%Stream.FileCharacter).%New()
    SET stream.LineTerminator = $Char(13,10)
    $$$TOE(sc,stream.LinkToFile(filename))
    RETURN stream
}

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

/// Description
ClassMethod GetDSName(counter As %Integer) As %Status
{
    SET ds = $CASE(counter,1:"synthetic",2:"hcanalytics",3:"globalsuicide",4:"covidpolls",5:"cancerrates",6:"overdosedeaths",
                           7:"hdprediction",8:"medicalservices",9:"hospitalratings",10:"patienttreatment",11:"diabetes",12:"kidneydisease",
                            :"Invalid")
    RETURN ds
}

// Remove particular Dataset or all datasets

ClassMethod RemoveDS(id As %Integer)
{
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter" 
        QUIT
    }
    
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
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    SET tSC=tRS.Execute(mDir,mFileSpec)
    
    WRITE "DATASET : "_ds,! 
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET filename=tRS.Get("Name")
        SET tableName=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        //Drop table 
        SET qry = "DROP TABLE "_tableName
        SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
      
        //Check if table deleted successfully
        IF rset.%SQLCODE
        {
             WRITE "ERROR : ",rset.%Message,!          
        } 
        ELSE
        {
            WRITE "Table "_tableName_" deleted successfully",!
        }
      }
   }
}

ClassMethod GetStatusDS(id As %Integer)
{
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter" 
        QUIT
    }
    
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
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    SET tSC=tRS.Execute(mDir,mFileSpec)
    
    WRITE "DATASET : "_ds,! 
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET filename=tRS.Get("Name")
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

ClassMethod GetDSTableName(id As %Integer) As %String
{
    SET ds = $CASE(id,11:"dc_data_synthetic.patients",12:"dc_data_synthetic.allergies",13:"dc_data_synthetic.careplans",4:"covidpolls",5:"cancerrates",6:"overdosedeaths",
                           7:"hdprediction",8:"medicalservices",9:"hospitalratings",10:"patienttreatment",11:"diabetes",12:"kidneydisease",
                            :"Invalid")
    RETURN ds
}

ClassMethod GetDSColNamesTH(id As %Integer) As %String
{
    set tblName = ..GetDSTableName(id)
    set myquery = "SELECT * FROM "_tblName
    SET tStatement = ##class(%SQL.Statement).%New(0)
    SET tStatement.%ObjectSelectMode=1
    SET qStatus = tStatement.%Prepare(myquery)
    IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
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

/// Description
ClassMethod GetDSRows(id As %Integer) As %String
{
  SET tblName = ..GetDSTableName(id)
  SET myquery = "SELECT * FROM "_tblName
  SET tStatement = ##class(%SQL.Statement).%New(0)
  SET tStatement.%ObjectSelectMode=1
  SET qStatus = tStatement.%Prepare(myquery)
  IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
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

ClassMethod GetTotalRecords(id As %Integer) As %String
{
  SET tblName = ..GetDSTableName(id)
  SET myquery = "SELECT COUNT(*) as total FROM "_tblName
  SET tStatement = ##class(%SQL.Statement).%New(0)
  SET qStatus = tStatement.%Prepare(myquery)
  IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
  SET rset = tStatement.%Execute()
  ///////////////////////
  IF rset.%SQLCODE=0 {
  DO rset.%Next() 
  RETURN rset.%GetData("total")
  }
  RETURN ""
}

}
