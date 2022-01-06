/// datasource from https://data.world/siyeh/synthetic-medical-data/workspace/project-summary?agentid=siyeh&datasetid=synthetic-medical-data
Class dc.data.medical.utility
{

ClassMethod importDS(id As %Integer)
{
    // Check if parameter is defined
    IF $DATA(id) '= 1 
    {
        WRITE "Invalid Parameter" 
        QUIT
    }
    // Get directory name based on parameter value
    SET ds = $CASE(id,1:"synthetic",2:"covid",3:"ood",4:"ps",5:"wdc",6:"hhcps",7:"bim",8:"brfv",:"Invalid")
    // Check if valid value is entered
    IF ds = "Invalid" 
    { 
        WRITE "Invalid Option"  
        QUIT  
    }    
    SET mDir = "/irisdev/app/src/data/"_ds
    SET mFileSpec = "*.csv"
    
    //User %ResultSet to read all the files from dirctory
    SET tRS=##class(%ResultSet).%New("%Library.File:FileSet")
    SET tSC=tRS.Execute(mDir,mFileSpec)
    
    //Get all the files from directory 
    WHILE tRS.Next() {
        SET filename=tRS.Get("Name")
        Kill classname
        kill coltype            
        //SET classname=$REPLACE("dc_data_synthetic."_tRS.Get("ItemName"),".csv","")
        SET classname=$REPLACE("dc_data_"_ds_"."_tRS.Get("ItemName"),".csv","")
        SET status=##class(dc.data.medical.utility).Process(filename,,.classname,.coltype,.tResults)	     
        //&sql( LOAD DATA FROM FILE %filename INTO %classname USING {"from":{"file":{"header":"1"}}})

        //Dynamically construct LOAD DATA statement
        SET qry = "LOAD DATA FROM FILE  '"_filename_"' INTO "_classname_ " "_"USING {""from"":{""file"":{""header"":""1""}}}"
        //set qry = "LOAD DATA FROM FILE %filename INTO %classname"
        //SET myquery = qry 
        //SET tStatement = ##class(%SQL.Statement).%New()
        //SET qStatus = tStatement.%Prepare(myquery)
        //IF qStatus'=1 
        //{
         //   WRITE "%Prepare failed:"
          //  DO $System.Status.DisplayError(qStatus) 
           // QUIT
        //}
        //SET rset = tStatement.%Execute()
        SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
        IF rset.%SQLCODE
        {
            WRITE "CLASSNAME :" _classname_" IMPORT FAILED: ",rset.%Message,!
        } else
        {
            WRITE "CLASSNAME :" _classname_" - "_rset.%ROWCOUNT_" Rows Imported Successfully",!
        }
            
      }
}

ClassMethod Process(filenamecsv As %String, dlm As %String = ",", ByRef classname As %String, ByRef coltype As %String, Output recordsCount As %Integer, pverbose As %Boolean = 1, pappend As %Boolean = 0) As %Status
{
    SET sc=$$$OK
    IF $g(coltype)="" {
       SET coltype=..GetColTypes(filenamecsv,dlm)     
    } 
    SET stc = ..CreateTbl(coltype,classname)
    QUIT sc
}

ClassMethod GetColTypes(filenamecsv As %String, dlm As %String = ",") As %String
{
    SET rowtypes=""
    SET stream=..GetStreamFromFile(filenamecsv)      
        SET header=stream.ReadLine() // Get Header columns
        //SET filename = stream.filename
        SET header=$ZCONVERT(header,"L")
        SET dataLine=stream.ReadLine() // Read First line of data
        //SET dataLine =..RemoveDlm(dataLine,dlm) // check it later

        //Read all the columns of header and add datatype against it        
        for i=1:1:($Length(header,dlm)) {
            kill types
            //Get datatype of the column
            do ##class(utility).GetDataType($Piece(dataLine,dlm,i),.types)
            SET type=##class(utility).GetType(.types) 
            //SET 200 Varchar
            if type="VARCHAR" SET type="VARCHAR(200)"
            SET $Piece(rowtypes,dlm,i)=$TR($Piece(header,dlm,i)," ","")_" "_type
    }

    SET rowtypes=$TR(rowtypes,dlm,",")
    // change "." symbol in column names
    SET rowtypes=$TR(rowtypes,".","_")
    Return rowtypes
}

ClassMethod GetStreamFromFile(filename As %String) As %Stream
{
    SET stream = ##Class(%Stream.FileCharacter).%New()
    SET stream.LineTerminator = $Char(13,10)
    $$$TOE(sc,stream.LinkToFile(filename))
    //SET filename = stream.FileName
    RETURN stream
}

ClassMethod CreateTbl(tblSql As %String, pp As %String) As %Status
{
 SET sc=$$$OK
 SET qry = "CREATE TABLE "_pp_" ("_tblSql_")"
 //SET myquery = qry 
 //SET tStatement = ##class(%SQL.Statement).%New()
 //SET qStatus = tStatement.%Prepare(myquery)
 //IF qStatus'=1 {WRITE "%Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
 //SET rset = tStatement.%Execute()
 //return sc

 SET rset = ##class(%SQL.Statement).%ExecDirect(,qry)
 IF rset.%SQLCODE
 {
    WRITE "ERROR WHILE CREATING TABLE : ",rset.%Message,!
 } 
 RETURN sc
}

ClassMethod IsDate(pVar As %String = "") As %Boolean
{
    SET result=$$$YES
    Try {
        If $ZDateH(pVar,5)
    }
    Catch e {
        SET result=$$$NO
    }
    Quit result
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

}
