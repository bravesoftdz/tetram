jQuery(document).ready(function () {
    
    $.datepicker.setDefaults({
        dateFormat: "dd M yy", 
        gotoCurrent: true, 
        changeMonth: true, 
        changeYear: true
    });
   
    $('.uidate').datepicker();
    $('.uibutton').button();
});