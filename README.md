# Medical DataSet

This dataset contains the core data to be used in projects for the textbook Introduction to Biomedical Data Science edited by Robert Hoyt MD FACP ABPM-CI, and Robert Muenchen MS PSAT (2019).

![Capture](https://user-images.githubusercontent.com/18219467/148702903-47b70d69-11c2-4777-8fb5-a04471147aa8.PNG)



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


