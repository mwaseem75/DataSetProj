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
    &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/patients.csv' INTO dc_data_health.Patients)
}

}
