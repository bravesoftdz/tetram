function AjaxGetContent(link)
{
	if (window.XMLHttpRequest) // FIREFOX
		xhr_object = new XMLHttpRequest();
	else if (window.ActiveXObject) // IE
		xhr_object = new ActiveXObject("Microsoft.XMLHTTP");
	else
		return(false);
		
	xhr_object.open("GET", 'ajax/' + link, false);
	xhr_object.send(null);
	if(xhr_object.readyState == 4) 
		return(xhr_object.responseText);
	else
		return(false);
}
