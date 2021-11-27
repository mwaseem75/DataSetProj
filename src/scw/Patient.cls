Class scw.Patient Extends (%Persistent, %Populate, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

Property Name As %String [ Required ];

Property Address As %String [ Required ];

Property Type As %String(VALUELIST = ",Staff,VIP,Company");

ClassMethod AddTestData(amount As %Integer = 10)
{
    d ..Populate(amount)
}

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Address</Value>
</Value>
</Data>
<DataLocation>^scw.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>10</ExtentSize>
<IdLocation>^scw.PatientD</IdLocation>
<IndexLocation>^scw.PatientI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Address">
<AverageFieldSize>38.5,City:9.1,State:4,Street:19.1,Zip:4.3</AverageFieldSize>
<Selectivity>10.0000%,City:11.1111%,State:11.1111%,Street:10.0000%,Zip:10.0000%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>18.3</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Type">
<AverageFieldSize>10</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^scw.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
