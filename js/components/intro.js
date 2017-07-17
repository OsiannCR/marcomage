/******************************************
 * MArcomage JavaScript - intro functions *
 ******************************************/

import $ from 'jquery';

export default function () {

$(document).ready(function() {
    let introDialog = $('#intro-dialog');

    // dialog is inactive
    if (introDialog.length === 0) {
        return;
    }

    // open dialog automatically
    introDialog.modal();

    // dismiss dialog callback
    introDialog.on('hidden.bs.modal', function() {
        let quickGame = $('button[name="quick_game"]');

        // start a new game if possible
        if (quickGame.length > 0) {
            quickGame.click();
        }
    });

});

}
