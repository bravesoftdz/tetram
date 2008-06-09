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

var
  waitMessage = 0;

function beginTask()
{
    getById("wait").style.display = "block";
}

function endTask()
{
    getById('wait').style.display = "none";
}

function _processupdate(id,link)
{
    getById(id).innerHTML = AjaxGetContent(link);
    endTask();
}

function AjaxUpdate(id, link)
{
    beginTask();
    
    setTimeout('_processupdate("'+id+'","'+link+'")', 10);
    
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