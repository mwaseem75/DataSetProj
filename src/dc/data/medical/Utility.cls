/// datasource from https://data.world/siyeh/synthetic-medical-data/workspace/project-summary?agentid=siyeh&datasetid=synthetic-medical-data
Class dc.data.medical.Utility
{

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
#;   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/patients.csv' INTO dc_data_health.Patients)
#;   }
   &sql(
      CREATE TABLE dc_data_health.Allergies (
      sratrdate CHAR(10) NULL,
      stopdate CHAR(10) NULL,
      patient CHAR(100) NULL,
      encounter CHAR(100) NULL,
      code NUMBER,
      description CHAR(100) NULL
   ))
#;   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/allergies.csv' INTO dc_data_health.Allergies)
#;   } 
   &sql(
      CREATE TABLE dc_data_health.AllPrevalences (       
      Item CHAR(100) NULL,
      PopulationType CHAR(25) NULL,
      Occurrence NUMBER,
      PopulationCount NUMBER,
      PrevalenceRate DECIMAL(6,3),
      PrevalencePercentage DECIMAL(6,3)
      ))
#;   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/all_prevalences.csv' INTO dc_data_health.AllPrevalences USING {"from":{"file":{"header":"1"}}})
#;   }

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
#;   IF SQLCODE > 0 {
      &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/careplans.csv' INTO dc_data_health.Careplans USING {"from":{"file":{"header":"1"}}})
#;   }   
 }
}
