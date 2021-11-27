/// Created using the page template: Column 2
Class scw.index Extends %ZEN.Component.page
{

/// Class name of application this page belongs to.
Parameter APPLICATION;

/// Displayed name of this page.
Parameter PAGENAME;

/// Domain used for localization.
Parameter DOMAIN;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
/* style for title bar */
#title {
	background: #C5D6D6;
	color: black;
	font-family: Verdana;
	font-size: 1.5em;
	font-weight: bold;
	padding: 5px;
	border-bottom: 1px solid black;
	text-align: center;
}
 
/* group on left-hand side */
#groupLeft {
	border-right: 1px solid black;
	background: #E0E0FF;
	height: 600px;
	width: 300px;
	overflow: auto;
}
 
/* group on right-hand side */
#groupRight {
	border-right: 1px solid black;
	background: #E0FFE0;
	height: 600px;
	overflow: auto;
}
 
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page xmlns="http://www.intersystems.com/zen" title="">
<html id="title">Title</html>
<hgroup id="hgroup" width="100%">
<vgroup id="groupLeft">
<!-- put contents of left column here -->
<html>Column 1</html>
</vgroup>
<vgroup id="groupRight">
<!-- put contents of right column here -->
<html>Column 2</html>
</vgroup>
</hgroup>
</page>
}

}
