function getById(id)
{
	isIE = (document.all);
	isNN6 = (!isIE) && (document.getElementById);
	if (isIE) menu = document.all[id];
	if (isNN6) menu = document.getElementById(id);
	return menu;
}

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

function AjaxUpdate(id, link)
{
	getById(id).innerHTML = AjaxGetContent(link);
	return false;
}


function Zoom(id, link, lien)
{
	element = getById(id);
	element.src = link;
	if (element.parentNode)
		element.parentNode.style.display = "";
	return false;
}