/// 
Class scw.DataForm Extends %ZEN.Component.page [ ProcedureBlock ]
{

Parameter APPLICATION;

Parameter CSSINCLUDES;

Parameter DOMAIN = "ZENDEMO";

Parameter PAGENAME = "scw.DataForm";

Property MyId As %Integer;

/// Provide localized text strings for use in the form.
Method %OnGetJSResources(ByRef pResources As %String) As %Status [ Private ]
{
 Set pResources("SuccessSaveRecord") = $$$Text("Record saved.")
 Set pResources("NothingRecord") = $$$Text("Enter an ID value. To view a list of IDs click Search.")
 Set pResources("NoExistRecord") = $$$Text("No record with this ID exists. To view a list of valid IDs click Search.") 
 Set pResources("ConfirmDelete") = $$$Text("Are you sure you want to delete this record? You cannot undo this operation.") 
 Set pResources("FailedDelete") = $$$Text("Record was not deleted.") 
 Set pResources("SuccessDelete") = $$$Text("Record deleted.") 
 Set pResources("LabelHide") = $$$Text("Hide")
 Set pResources("LabelTitleHide") = $$$Text("Hide display of current records")
 Set pResources("LabelSearch") = $$$Text("Search")
 Set pResources("LabelTitleHide") = $$$Text("Find all records")
 Set pResources("FailedDataValidation") = $$$Text("Some data was incorrect or incomplete. Please try again. To view tips for entering the correct data format for a field, hover the cursor over the field (or its title) and wait for a tooltip to display"_ $c(13,10,13,10)) 
 
 Set pResources("RequiredName") = $$$Text("Name is a required field, but it was empty."_$c(13,10))
 Set pResources("FailedStringName") = $$$Text("Name was too short or too long."_$c(13,10))
 Set pResources("FailedStringType") = $$$Text("Type was too short or too long."_$c(13,10))
 
 Quit $$$OK
}

ClassMethod ModelIdExists(modelId As %String) As %Boolean [ ZenMethod ]
{
 if ($classmethod("scw.Patient","%ExistsId",modelId)) {
  Quit 1
 }
 else {
  Quit 0
 }
}

ClientMethod deleteRec() As %Status [ Language = javascript ]
{
 var id = zen('ID');
 var val = id.getValue();
 if (val.length <= 0) {
  alert(zenText('NothingRecord'));
  return false;
 }
 if (zenPage.ModelIdExists(val) == 0) {
  alert(zenText('NoExistRecord'));
  return false;
 }
 if (confirm(zenText('ConfirmDelete'))) {
  var controller = zen('mvc');
  controller.deleteId(controller.getModelId());
  controller.createNewObject();
  controller.update();
  if (id.setValue('') == false) {
 	 alert(zenText('FailedDelete'));
 	 return false;
  }
  alert(zenText('SuccessDelete'));
  return false;
 }
 else {
  alert(zenText('FailedDelete'));
  return false;
 }
}

ClientMethod getRecord(id As %Integer) As %Status [ Language = javascript ]
{
 var controller = zen('mvc');
 controller.setModelId(id);
 var idText = id.toString();
 zenPage.MyId = idText;
 var id = zen('ID');
 id.setValue(idText);
}

/// Hide the table of records on the form.
ClientMethod hideSearchTable() As %Status [ Language = javascript ]
{
 var tab = zen('searchTable');
 tab.setHidden(true); 
 var btn = zen('btnSearch'); 
 btn.caption = zenText('LabelSearch'); 
 btn.title = zenText('LabelTitleSearch');
 zenPage.refreshContents();
}

ClientMethod newRec() As %Status [ Language = javascript ]
{
 var id = zen('ID');
 id.setValue('');
 var controller = zen('mvc');
 controller.createNewObject();
}

/// Refresh the table of records on the form.
ClientMethod refreshSearchTable() As %Status [ Language = javascript ]
{
 var tab = zen('searchTable');
 if (tab.hidden == false) { 
   tab.executeQuery(); 
 }
}

ClientMethod saveRec(ok) As %Status [ Language = javascript ]
{
 if (ok == true) {
  var form=zen('DataForm');
  var save=form.save();
  if (save.length == 0) ok = false;
  else var cls=zen('mvc').getModelClass();
 }
 if (ok == true) alert(zenText('SuccessSaveRecord'));
 else alert(zenText('FailedDataValidation'));
 return ok;
}

/// Display the table of records on the form.
ClientMethod toggleSearchTable() As %Status [ Language = javascript ]
{
 var tab = zen('searchTable');
 if (tab.hidden == true) { 
  tab.setHidden(false); 
  var btn = zen('btnSearch'); 
  btn.caption = zenText('LabelHide');
  btn.title = zenText('LabelTitleHide'); 
  tab.executeQuery(); 
  zenPage.refreshContents(); 
 } 
 else { 
  zenPage.hideSearchTable(); 
 }
}

/// Refresh the table of records on the form.
ClientMethod validateAndSave() As %String [ Language = javascript ]
{
 var msg = '';
 if (zenPage.validateRequired('Name') == false)
  msg += zenText('RequiredName');
 if (msg.length == 0) zenPage.saveRec(true);
 else alert(zenText('FailedDataValidation') + msg);
}

ClientMethod validateDate(fname As %String) As %Status [ Language = javascript ]
{
 return zenPage.validateDateField(zen(fname).getValue());
}

ClientMethod validateDateField(field As %String) As %Status [ Language = javascript ]
{
 var len = field.length;
 if (len < 10) return false;
 if (field.charAt(4) != '-') return false;
 if (field.charAt(7) != '-') return false;
 var part = field.split('-');
 if (part.length != 3) return false;
 if (zenPage.validateYear(part[0]) == false) return false;
 if (zenPage.validateMonthDay(part[1],part[2]) == false) return false;
 return true;
}

ClientMethod validateDecimal(fname As %String) As %Status [ Language = javascript ]
{
 var field = (zen(fname)).getValue();
 var part = field.split('.');
 var len = part.length;
 if ((len <= 0) || (part.length > 2)) return false;
 for (i = 0; i < len; i++) {
 	 if (isNaN(part[i])) return false;
 }
 return true;
}

ClientMethod validateHour(field As %String) As %Status [ Language = javascript ]
{
 var val = parseInt(field); 
 return ((val >= 0) && (val <= 23));
}

ClientMethod validateInteger(fname As %String, haveMin As %Boolean, min As %Integer, haveMax As %Boolean, max As %Integer) As %Status [ Language = javascript ]
{
 var field = (zen(fname)).getValue(); 
 if (isNaN(field)) return false; 
 if ((haveMin == true) && (field < min)) return false; 
 if ((haveMax == true) && (field > max)) return false; 
 return true;
}

ClientMethod validateMinute(field As %String) As %Status [ Language = javascript ]
{
 var val = parseInt(field); 
 return ((val >= 0) && (val <= 59));
}

ClientMethod validateMonthDay(field1 As %String, field2 As %String) As %Status [ Language = javascript ]
{
 var m = parseInt(field1);
 var d = parseInt(field2);
 if ((m >= 1) && (m <= 12) && (d >= 1) && (d <= 31)) {
	 if ((m == 4) || (m == 6) || (m == 9) || (m == 11)) {
		 if (d <= 30) return true;
	 }
	 else if (m == 2) {
		 if (d <= 29) return true;
	 }
	 else return true;
 }
 return false;
}

ClassMethod DrawHTML() As %Status
{
       
    &html<<ul>>
    &html<<li><a href="http://127.0.0.1:52773/csp/sys/%25CSP.Portal.Home.zen?IRISLogout=end">Management Portal</a></li>>
    &html<<li><a href="http://localhost:52773/terminal/">Web Terminal</a></li>>
    &html<<li><a href="http://localhost:52773/csp/user/list.csp">Main Tasks</a></li>>
    &html<<li><a href="http://localhost:52773/csp/user/scw.DataForm.cls">Data Form</a></li>>
    &html<<li><a href="http://localhost:52773/csp/user/scw.Login.cls">Login</a></li>>
    &html<</ul>>

    &html<<br><br>>
    &html<<h2>User : #($UserName)#<h2>>
    &html<<h2>Roles : #($ROLES)#<h2>>
    Quit $$$OK
}

ClientMethod validateRequired(fname As %String) As %Status [ Language = javascript ]
{
 var field = (zen(fname)).getValue();
 if (field.length == 0) return false;
 else return true;
}

ClientMethod validateString(fname As %String, haveMin As %Boolean, min As %Integer, haveMax As %Boolean, max As %Integer) As %Status [ Language = javascript ]
{
 var field = (zen(fname)).getValue(); 
 var len = field.length; 
 if ((haveMin == true) && (len < min)) return false; 
 if ((haveMax == true) && (len > max)) return false; 
 else return true;
}

ClientMethod validateTime(fname As %String) As %Status [ Language = javascript ]
{
  return zenPage.validateTimeField(zen(fname).getValue());
}

ClientMethod validateTimeField(field As %String) As %Status [ Language = javascript ]
{
 var len = field.length;
 if (len < 8) return false;
 if (field.charAt(2) != ':') return false;
 if (field.charAt(5) != ':') return false;
 var part = field.split(':');
 if (part.length != 3) return false;
 if (zenPage.validateHour(part[0]) == false) return false;
 if (zenPage.validateMinute(part[1]) == false) return false;
 if (zenPage.validateMinute(part[2]) == false) return false;
 return true;
}

ClientMethod validateTimeStamp(fname As %String) As %Status [ Language = javascript ]
{
 var field = zen(fname).getValue();
 var len = field.length;
 if (len < 18) return false;
 var part = field.split(' ');
 if (part.length != 2) return false;
 if (zenPage.validateDateField(part[0]) == false) return false;
 if (zenPage.validateTimeField(part[1]) == false) return false;
 return true;
}

ClientMethod validateYear(field As %String) As %Status [ Language = javascript ]
{
 var val = parseInt(field); 
 return ((val >= 0) && (val <= 9999));
}

ClientMethod viewRec() As %Status [ Language = javascript ]
{
 var id = zen('ID');
 var val = id.getValue();
 if (val.length <= 0) {
  alert(zenText('NothingRecord'));
  return false;
 }
 if (zenPage.ModelIdExists(val) == 0) {
  alert(zenText('NoExistRecord'));
  return false;
 }
}

XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="Data_APP_Security" >
<dataController id="mvc" modelClass="scw.Patient" modelId="" />

 <html OnDrawContent="DrawHTML"></html>
 
<form controllerId="mvc" id="DataForm" width="100%" >
<spacer height="10" />
<vgroup align="left" valign="top" labelPosition="left" >
<hgroup>
<button id="btnNew" caption="New" title="Clear all fields so that you can create a new record" onclick="zenPage.newRec();"/>
<button id="btnView" caption="View" title="To edit or delete a record, enter the number in the ID field, then click this button" onclick="zenPage.viewRec();"/>
<button id="btnSave" caption="Save" title="Save the record currently in view" onclick="zenPage.validateAndSave(); zenPage.refreshSearchTable();"/>
<button id="btnDelete" caption="Delete" title="Delete the record currently in view" onclick="zenPage.deleteRec(); zenPage.refreshSearchTable();" />
<button id="btnSearch" caption="Search" title="Find all records" onclick="zenPage.toggleSearchTable();" />
</hgroup>
<spacer height="10" />
 <text label="(System Assigned) ID" id="ID" title="System assigned identifier. Do not edit when creating a new record." size="10" value="#(%page.MyId)#" height="23" onblur="zenPage.getRecord(zenThis.getValue());" />
 <text id="Name"  label="Name *" title="Enter a value" size="50" dataBinding="Name" height="23" />
 <combobox id="Type" label="Type" valueList=",Staff,VIP,Company" title="Choose a value" dropdownHeight="100" dropdownWidth="200" dataBinding="Type" />
 <html id="requiredText" >* Indicates a required field</html>
   <spacer height="20" />
   <tablePane id="searchTable" hidden="true" maxRows="50" sql="SELECT * FROM scw.Patient ORDER BY ID" >
     <column colName="ID" link="javascript:zenPage.getRecord(#(%query.ID)#);" />
   </tablePane>
   <spacer height="10" />
  </vgroup>
 </form>
 

</page>
}

XData Style
{
<style type="text/css">
body { font-family: arial; }

     table.tpTable caption{
       background: transparent;
       font-size: 1.4em;
       font-weight: bold;
       text-align: left;
       border: none;
     }

    /* even rows */
     .tpEven { color: black; background: #ebf3ff; }
    
    /* odd rows */
     .tpOdd { color: black; background: white; }

    /* this is a selected row */
     table.tpTable tr.tpSelected { background: #3d80df; color: white; }
   
    /* hover for odd and even rows */
     tr.tpOdd:hover,tr.tpEven:hover { 
        background-color: #3d80df; 
        color: #ffffff; }
  
    /* table header style */
    table.tpTable th {
        border-right: 1px solid gray;
        border-bottom: 1px solid gray;
        background: #C5D6D6;
        color: black;
        font-weight: bold;
        text-align: left;
        padding: 2px;
        overflow: hidden;
     }

    /* selected column header (th) */
     table.tpTable th.tpHdrSelected { background: #3d80df; }

    /* filter layout */
     table.tpFilterLayout td { border: none; background: #C5D6D6; }
ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
  background-color: #2b3589;
}

li {
  float: left;
}

li a {
  display: block;
  color: white;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
}

/* Change the link color to #111 (black) on hover */
li a:hover {
  background-color: #111;
}
</style>
}

}
