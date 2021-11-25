Class dataapp.Patient Extends (%Persistent, %Populate, %XML.Adaptor, %ZEN.DataModel.Adaptor)
{

Property Name As %String [ Required ];

Property Type As %String(VALUELIST = ",Insurance,VIP");

Property Home As dataapp.Address;

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
<Value>Home</Value>
</Value>
</Data>
<DataLocation>^dataapp.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^dataapp.PatientD</IdLocation>
<IndexLocation>^dataapp.PatientI</IndexLocation>
<StreamLocation>^dataapp.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
