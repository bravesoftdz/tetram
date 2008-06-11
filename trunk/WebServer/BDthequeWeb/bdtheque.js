function Zoom(id, link)
{
	var element = getById(id);
	element.src = link;
	if (element.parentNode)
		element.parentNode.style.display = "";
	return false;
}

var waitMessage = 0;
var historique = new Array();
var historiqueLabels = new Array();
var posHistorique = -1;

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

function AjaxUpdate(id, link, label, norefresh)
{
	if (id == 'detail' && !(norefresh === true) && (posHistorique == -1 || historique[posHistorique] != link) )
	{
		historique[++posHistorique] = link;
		historiqueLabels[posHistorique] = label;
		if (posHistorique < historique.length - 1) 
		{
			historique.length = posHistorique + 1;
			historiqueLabels.length = posHistorique + 1;
		}
		refreshNavigation();
	}
	
	beginTask();
	
	setTimeout('_processupdate("'+id+'","'+link+'")', 10);
	
	return false;
}

function showHistorique(position)
{
	AjaxUpdate('detail', historique[position], '', true);
	posHistorique = position;
	refreshNavigation(); 
	return true;
}

function backHistorique()
{
	if (posHistorique > 0) showHistorique(posHistorique - 1);
	return true;
}

function forwardHistorique()
{
	if (posHistorique < historique.length - 1)	showHistorique(posHistorique + 1);
	return true;
}

var hideHistoriqueTimer = 0;

function hideHistorique()
{
	if (hideHistoriqueTimer) 
	{
		clearTimeout(hideHistoriqueTimer);
		hideHistoriqueTimer = 0;
	}
	var divListe = getById('listeHistoriqueBack');
	divListe.className = divListe.className.replace(new RegExp(" show\\b"), ""); 
	var divListe = getById('listeHistoriqueForward');
	divListe.className = divListe.className.replace(new RegExp(" show\\b"), ""); 
	return true;
}

function refreshNavigation()
{
	hideHistorique();
	var backBtn = getById('historiqueBack');
	if (backBtn)
	{
		var newClass = backBtn.className.replace(new RegExp(" disabled\\b"), ""); 
		if (posHistorique > 0) 
			backBtn.className = newClass;
		else
			backBtn.className = newClass + ' disabled';
	}
	var fwdBtn = getById('historiqueForward');
	if (fwdBtn)
	{
		var newClass = fwdBtn.className.replace(new RegExp(" disabled\\b"), ""); 
		if (posHistorique < historique.length - 1)
			fwdBtn.className = newClass;
		else
			fwdBtn.className = newClass + ' disabled';
	}
	return true;
}

function resetHistoriqueTimer()
{
	if (hideHistoriqueTimer) clearTimeout(hideHistoriqueTimer);
	hideHistoriqueTimer = setTimeout('hideHistorique()', 2000);
	return true;
}

function showListeHistorique(isBack)
{
	function formatPage(label, i)
	{
		if (label && label != '')
			return label;
		else
			return 'Page ' + i;
	}

	if (isBack === true)
		var divListe = getById('listeHistoriqueBack');
	else
		var divListe = getById('listeHistoriqueForward');
	var s = '';
	if (isBack === true)
		for(i = posHistorique - 1, c = 0; i >= 0 && c < 10; i--, c++)
			s = '<a href=# onclick="showHistorique(' + i + ')">' + formatPage(historiqueLabels[i], i) + '</a><br>' + s;
	else
		for(i = posHistorique + 1, c = 0; i <= historique.length - 1 && c < 10; i++, c++)
			s = '<a href=# onclick="showHistorique(' + i + ')">' + formatPage(historiqueLabels[i], i) + '</a><br>' + s;
			
	if (s != '') 
	{
		divListe.innerHTML = s;
		divListe.className = divListe.className.replace(new RegExp(" show\\b"), "") + ' show'; 
		resetHistoriqueTimer();
	}
	
	return true;
}