$(function () {
    
    $.datepicker.setDefaults({
        dateFormat: "dd M yy", 
        gotoCurrent: true, 
        changeMonth: true, 
        changeYear: true
    });
   
    $('.uidate').datepicker();
    
    $('.uibutton').button();
    
    $('.uiaccordion').accordion({
        header: "h3"
    });

    $('.uitabsv').tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
    $('.uitabsv li').removeClass('ui-corner-top').addClass('ui-corner-left');
    $('.uitabsh,.uitabsv').tabs({
        beforeLoad: function( event, ui ) {
            ui.jqXHR.error(function() {
                ui.panel.html(
                    "Couldn't load this tab. We'll try to fix this as soon as possible. " +
                    "If this wouldn't be a demo." );
            });
        }
    });

});