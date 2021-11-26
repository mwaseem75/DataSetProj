Class scw.Patient Extends (%Persistent, %Populate, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

Property Name As %String [ Required ];

Property Type As %String(VALUELIST = ",Business,Personal");

Property Address As scw.Address;

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
<IdLocation>^scw.PatientD</IdLocation>
<IndexLocation>^scw.PatientI</IndexLocation>
<StreamLocation>^scw.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
