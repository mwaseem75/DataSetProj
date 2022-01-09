# Medical DataSet

14 DataSets containg 43 tables based on datasets from data.world and kaggle.com 
Application to create tables dynamically based on the files in folder and Load data by using all-new LOAD DATA InterSystems IRIS 2021.2 Preview functionality.
DataSet can be installed or removed by terminal or by using web application. Data can be view and copied by using Web application.

![image](https://user-images.githubusercontent.com/18219467/148703381-c1ca7868-0f23-4b65-bc11-1c38808ac666.png)



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


