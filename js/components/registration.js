/**
 * MArcomage JavaScript - Registration section
 */

import $ from 'jquery';

export default function () {
  $(document).ready(() => {
    const dic = $.dic;

    if (!dic.bodyData().isSectionActive('registration')) {
      return;
    }

    const notification = dic.notificationsManager();
    const newUsername = $('input[name="new_username"]');

    // set focus on login name
    newUsername.focus();

    // login name input handling
    newUsername.keypress((event) => {
      if (event.keyCode === dic.KEY_ENTER) {
        event.preventDefault();

        // login name is specified - move cursor to the next input
        if ($('input[name="new_username"]').val() !== '') {
          $('input[name="new_password"]').focus();
        }
      }
    });

    // new password input handling
    $('input[name="new_password"]').keypress((event) => {
      if (event.keyCode === dic.KEY_ENTER) {
        event.preventDefault();

        // new password is specified - move cursor to the next input
        if ($('input[name="new_password"]').val() !== '') {
          $('input[name="confirm_password"]').focus();
        }
      }
    });

    // new password confirmation input handling
    $('input[name="confirm_password"]').keypress((event) => {
      if (event.keyCode === dic.KEY_ENTER) {
        event.preventDefault();

        // new password is specified - execute register
        if ($('input[name="confirm_password"]').val() !== '') {
          $('button[name="register"]').click();
        }
      }
    });

    // validate captcha before submission
    $('button[name="register"]').click(() => {
      // validate only if CAPTCHA is present
      if ($('.g-recaptcha').length > 0 && $('#g-recaptcha-response').val() === '') {
        notification.displayInfo('Mandatory input is missing', 'Please fill out CAPTCHA');
        return false;
      }

      return true;
    });
  });
}
