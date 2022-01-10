## Summary
14 DataSets containg 43 tables based on datasets from data.world and kaggle.com 
Application to create tables dynamically based on the files in folder and Load data by using all-new LOAD DATA InterSystems IRIS 2021.2 Preview functionality.
DataSet can be installed or removed by terminal or by using web application. Data can be view and copied by using Web application.

![image](https://user-images.githubusercontent.com/18219467/148703381-c1ca7868-0f23-4b65-bc11-1c38808ac666.png)
## Datasets List
* 1 - Synthetic Medical Data 
* 2 - Health Care Analytics - 1
* 3 - Global Suicide Data
* 4 - COVID-19 Polls
* 5 - Cancer Rates by U.S. State
* 6 - Opioid Overdose Deaths 
* 7 - Heart Disease Prediction
* 8 - Yellowpages medical services dataset
* 9 - Hospital ratings
* 10 -Patient Treatment Classification
* 11 -Diabetes Dataset
* 12 -Chronic Kidney Disease

## Features
* Dynamically creation of table based on the CSV file data.
* Import dataset by using LOAD DATA funtionality by Terminal or by web applicaton.
* Remove dataset programatically by terminal or by Web Application.
* Dynamcially view Imported Data from Web Application.
* Funtionality to Import data into CSV, Excel or PDF Format. 
* Responsive web application to view the status of Dataset.
* All datasets can be imported or removed by single command.



## How to Run

To start coding with this repo, you do the following:

1. Clone/git pull the repo into any local directory

```shell
git clone https://github.com/mwaseem75/DataSetProj.git
```

2. Open the terminal in this directory and run:

```shell
docker-compose build
```

3. Run the IRIS container with your project:

```shell
docker-compose up -d
```

## How to test

Open command prompt from terminal
docker-compose exec iris iris session iris

Change name space to "DATASETS"
zn "DATASETS"

Start SQL Shell
DO $SYSTEM.SQL.Shell()

Select loaded Records from patients table
SELECT * FROM dc_data_health.Patients


