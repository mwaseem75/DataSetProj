## Summary
14 DataSets containg 43 tables based on datasets from data.world and kaggle.com 
Application to create tables dynamically based on the files in folder and Load data by using all-new LOAD DATA InterSystems IRIS 2021.2 Preview functionality.
DataSet can be installed or removed by terminal or by using web application. Data can be view and copied by using Web application.

## Application Layout
![image](https://user-images.githubusercontent.com/18219467/148703381-c1ca7868-0f23-4b65-bc11-1c38808ac666.png)
## Datasets List
* **1 - Synthetic Medical Data** : Synthetic medical record data for Introduction to Biomedical Data Science. [LICENCE:Public Domain](https://data.world/siyeh/synthetic-medical-data)
* **2 - Health Care Analytics - 1** : Part of Janatahack Hackathon in Analytics Vidhya [LICENCE:Public Domain](https://www.kaggle.com/abisheksudarshan/health-care-analytics)
* **3 - Global Suicide Data** : World Health Organization (WHO) dataset [LICENCE:Public Domain](https://www.kaggle.com/sathutr/global-suicide-data?select=suicide_by_age.csv)
* **4 - COVID-19 Polls** : Survey data to understand how Americans view the coronavirus pandemic and the president's response [LICENCE:CC-BY](https://data.world/fivethirtyeight/covid-19-polls)
* **5 - Cancer Rates by U.S. State** : The rates are the numbers out of 100,000 people who developed or died from cancer each year. [LICENCE:Public Domain](https://data.world/adamhelsinger/cancer-rates-by-u-s-state)
* **6 - Opioid Overdose Deaths** : Opioid addiction and death rates in the U.S. and abroad have reached "epidemic" levels. The CDC's data reflects the incredible spike in overdoses caused by drugs containing opioids. [LICENCE:Public Domain](https://data.world/health/opioid-overdose-deaths)
* **7 - Heart Disease Prediction** : This data set came from the University of California Irvine data repository and is used to predict heart disease [LICENCE:Public Domain](https://data.world/informatics-edu/heart-disease-prediction)
* **8 - Yellowpages medical services dataset** : Yellowpages dataset with more than 400K+ records from Crawl Feeds. [LICENCE:Public Domain](https://data.world/crawlfeeds/yellowpages-medical-services-dataset)
* **9 - Hospital ratings** : This are the official datasets used on the Medicare.gov Hospital Compare Website provided by the Centers for Medicare & Medicaid Services. These data allow you to compare the quality of care at over 4,000 Medicare-certified hospitals across the country.  [LICENCE:Public Domain](https://www.kaggle.com/center-for-medicare-and-medicaid/hospital-ratings)
* **10 -Heart Failure Prediction** : 12 clinical features por predicting death events. [LICENCE:Attribution 4.0 International (CC BY 4.0)](https://www.kaggle.com/andrewmvd/heart-failure-clinical-data) 
* **11 -Diabetes Dataset** : This dataset is originally from the National Institute of Diabetes and Digestive and Kidney Diseases. The objective is to predict based on diagnostic measurements whether a patient has diabetes. [LICENCE:Public Domain](https://www.kaggle.com/mathchi/diabetes-data-set)
* **12 -Chronic Kidney Disease** : This dataset is originally from UCI Machine Learning Repository. The objective of the dataset is to diagnostically predict whether a patient is having chronic kidney disease or not, based on certain diagnostic measurements included in the dataset.  [LICENCE:Public Domain](https://www.kaggle.com/mathchi/diabetes-data-set)

## Features
* Dynamically creation of table based on the CSV file data.
* Import dataset by using LOAD DATA funtionality by Terminal or by web applicaton.
* Remove dataset programatically by terminal or by Web Application.
* Dynamcially view Imported Data from Web Application.
* Funtionality to Import data into CSV, Excel or PDF Format. 
* Responsive web application to view the status of Dataset.
* All datasets can be imported or removed by single command.

## Recommendation 
 * Read related documentations [LOAD DATA (SQL)](https://irisdocs.intersystems.com/iris20212/csp/docbook/DocBook.UI.Page.cls?KEY=RSQL_loaddata).


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

## Repo Contents   
* Dockerfile, docker-compose.yml, and Installer.cls to create container
* iris.script, contains script to execute during container initialization 
* /src with source files 
* /.vscode/settings.json for automatic server connections when opened in VS Code.

## Requirements:  
* [Docker desktop]( https://www.docker.com/products/docker-desktop)
* Get the latest InterSystems IRIS for Health image for use in the Dockerfile: https://hub.docker.com/_/intersystems-iris-for-health  

## Getting Started 
## Importing DataSet
###### Run below command to import particular dataset by providing dataset ID (From Terminal)
```
do ##class(dc.
```


Change name space to "DATASETS"
zn "DATASETS"

Start SQL Shell
DO $SYSTEM.SQL.Shell()

Select loaded Records from patients table
SELECT * FROM dc_data_health.Patients


