/// datasource from https://data.world/informatics-edu/heart-disease-prediction/workspace/data-dictionary 
Class dc.data.health.HeartDisease Extends %Persistent [ SqlRowIdPrivate ]
{

// in years

Property age As %Library.Integer;

// (1 = male; 0 = female)

Property sex As %Library.Integer;

// Value 1: typical angina -- Value 2: atypical angina -- 

// Value 3: non-anginal pain -- Value 4: asymptomati
}