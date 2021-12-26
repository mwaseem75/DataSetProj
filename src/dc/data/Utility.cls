Class dc.data.Utility
{

ClassMethod CreateTable()
{
   //
   &sql( CREATE TABLE dc_data_health.Employee  (
                            Name CHAR(100) NULL,
                            Position CHAR(100) NULL,
                            Office    CHAR(100) NULL,
                            Age  INTEGER NULL,
                            Salary DECIMAL(15,2)
))

 &sql( LOAD DATA FROM FILE '/opt/irisapp/src/data/employees.csv' INTO dc_data_health.Employee)
}

}
