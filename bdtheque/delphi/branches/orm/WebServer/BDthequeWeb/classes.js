var selectedTabs = new Array();

function treeLoad(id, link, parent)
{
    AjaxUpdate(id, link);
    getById(id).style.display = "";
    parent.onclick = function onclick(event) { return swap(id); };
    return true;
}

function selectTab(id, link, tab, tabcontrol)
{
	AjaxUpdate(id, link);

	var new_tab = getById(tab);
	if (new_tab) new_tab.className = 'tabsheet_selected';

	var old_tab = getById(selectedTabs[tabcontrol]);
	if (old_tab) old_tab.className = 'tabsheet';
	
	selectedTabs[tabcontrol] = tab;
	return true;
}