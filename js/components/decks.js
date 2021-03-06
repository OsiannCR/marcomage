/**
 * MArcomage JavaScript - Decks section
 */

import $ from 'jquery';

export default function () {
  /**
   * Add card to deck via AJAX
   * @param {int}cardId
   * @returns {boolean}
   */
  function takeCard(cardId) {
    const dic = $.dic;
    const card = '#card_'.concat(cardId);
    const deckId = $('input[name="current_deck"]').val();
    const api = dic.apiManager();
    const notification = dic.notificationsManager();

    api.takeCard(deckId, cardId, (result) => {
      // AJAX failed, display error message
      if (result.error) {
        notification.displayError(result.error);
        return;
      }

      const slot = '#slot_'.concat(result.slot);
      const takenCard = result.taken_card;

      // move selected card to deck
      // disallow the card to be removed from the deck (prevent double clicks)
      $(card).removeAttr('data-take-card');
      $(card).unbind('click');

      $(card).find('.card').animate({ opacity: 0.6 }, 'slow', () => {
        $(slot).html(takenCard);

        // initialize hint tooltip for newly added card
        $(slot).find('[title]').tooltip({
          classes: {
            'ui-tooltip': 'ui-corner-all ui-widget-shadow',
          },
          placement: 'auto bottom',
        });

        // mark card as taken
        $(card).addClass('card-pool__card-slot--taken');
        $(slot).find('.card').css('opacity', 1);
        $(slot).hide();
        $(slot).fadeIn('slow');

        // allow a card to be removed from deck
        $(slot).attr('data-remove-card', cardId);
        $(slot).click(function () {
          const slotCardId = parseInt($(this).attr('data-remove-card'), 10);

          return removeCard(slotCardId);
        });
      });

      // update tokens when needed
      if (result.tokens !== 'no') {
        let token;

        $('#tokens-selection').find('select').each(function (i) {
          token = document.getElementsByName('Token'.concat(i + 1)).item(0);
          $(this).find('option').each(function (j) {
            if ($(this).val() === result.tokens[i + 1]) {
              token.selectedIndex = j;
            }
          });
        });
      }

      // recalculate avg cost per turn
      $('#cost-per-turn').find('b').each(function (i) {
        $(this).html(result.avg[i]);
      });
    });

    // disable standard processing
    return false;
  }

  /**
   * Remove card from deck via AJAX
   * @param {int}cardId
   * @returns {boolean}
   */
  function removeCard(cardId) {
    const dic = $.dic;
    const card = '#card_'.concat(cardId);
    const deckId = $('input[name="current_deck"]').val();
    const api = dic.apiManager();
    const notification = dic.notificationsManager();

    api.removeCard(deckId, cardId, (result) => {
      // AJAX failed, display error message
      if (result.error) {
        notification.displayError(result.error);
        return;
      }

      const slot = '#slot_'.concat(result.slot);
      const empty = result.slot_html;

      // move selected card to card pool

      // disallow the card to be removed from the deck (prevent double clicks)
      $(slot).removeAttr('data-remove-card');
      $(slot).unbind('click');

      // remove return card button
      $(slot).find('noscript').remove();

      // unmark card as taken
      $(card).removeClass('card-pool__card-slot--taken');
      $(card).find('.card').css('opacity', 0.6);

      // allow a card to be removed from card pool
      $(card).attr('data-take-card', cardId);
      $(card).click(function () {
        const slotCardId = parseInt($(this).attr('data-take-card'), 10);

        return takeCard(slotCardId);
      });

      $(slot).fadeOut('slow', () => {
        $(slot).html(empty);
        $(slot).show();
        $(card).find('.card').animate({ opacity: 1 }, 'slow');
      });

      // recalculate avg cost per turn
      $('#cost-per-turn').find('b').each(function (i) {
        $(this).html(result.avg[i]);
      });
    });

    // disable standard processing
    return false;
  }

  $(document).ready(() => {
    const dic = $.dic;

    if (!dic.bodyData().isSectionActive('decks')) {
      return;
    }

    const api = dic.apiManager();
    const notification = dic.notificationsManager();
    let confirmed = false;

    // apply card filters by pressing ENTER key
    $('input[name="name_filter"]').keypress((event) => {
      if (event.keyCode === dic.KEY_ENTER) {
        event.preventDefault();
        $('button[name="deck_apply_filters"]').click();
      }
    });

    // card pool lock
    let cardPoolLock = false;

    // show/hide card pool
    $('button[name="card_pool_switch"]').click(function () {
      const cardPool = $('#card-pool');
      const cardPoolSwitch = $(this);
      const cardPoolIcon = $(this).find('span');

      // card pool is locked
      if (cardPoolLock) {
        return false;
      }

      if (cardPoolSwitch.hasClass('show-card-pool')) {
        // show card pool
        // block switch button while animating
        cardPoolLock = true;

        // repair card pool state if necessary
        cardPool.hide();
        cardPool.css('height', 'hide');
        cardPool.css('opacity', 0);

        // expand card pool
        cardPool.animate({ height: 'show' }, 'slow', () => {
          $('#card-pool').animate({ opacity: 1 }, 'slow', () => {
            $('#card-pool').show();

            // update hidden data element
            $('input[name="card_pool"]').val('yes');

            // unlock card pool
            cardPoolSwitch.removeClass('show-card-pool');
            cardPoolSwitch.addClass('hide-card-pool');
            cardPoolIcon.removeClass('glyphicon-resize-full');
            cardPoolIcon.addClass('glyphicon-resize-small');
            cardPoolLock = false;
          });
        });
      } else if (cardPoolSwitch.hasClass('hide-card-pool')) {
        // hide card pool
        // block switch button while animating
        cardPoolLock = true;

        // repair card pool state if necessary
        cardPool.show();

        // collapse card pool
        cardPool.animate({ opacity: 0 }, 'slow', () => {
          $('#card-pool').animate({ height: 'hide' }, 'slow', () => {
            $('#card-pool').hide();

            // update hidden data element
            $('input[name="card_pool"]').val('no');

            // unlock card pool
            cardPoolSwitch.removeClass('hide-card-pool');
            cardPoolSwitch.addClass('show-card-pool');
            cardPoolIcon.removeClass('glyphicon-resize-small');
            cardPoolIcon.addClass('glyphicon-resize-full');
            cardPoolLock = false;
          });
        });
      }

      return false;
    });

    // deck reset confirmation
    $('button[name="reset_deck_prepare"]').click(function () {
      // action was already approved
      if (confirmed) {
        // skip standard confirmation
        $('button[name="reset_deck_prepare"]').attr('name', 'reset_deck_confirm');
        return true;
      }

      const triggerButton = $(this);
      const message = 'All cards will be removed from the deck, all token counters will be reset and deck statistics will be reset as well. Are you sure you want to continue?';

      // request confirmation
      notification.displayConfirm('Action confirmation', message, (result) => {
        if (result) {
          // pass confirmation
          confirmed = true;
          triggerButton.click();
        }
      });

      return false;
    });

    // deck statistics reset confirmation
    $('button[name="reset_stats_prepare"]').click(function () {
      // action was already approved
      if (confirmed) {
        // skip standard confirmation
        $('button[name="reset_stats_prepare"]').attr('name', 'reset_stats_confirm');
        return true;
      }

      const triggerButton = $(this);
      const message = 'Deck statistics will be reset. Are you sure you want to continue?';

      // request confirmation
      notification.displayConfirm('Action confirmation', message, (result) => {
        if (result) {
          // pass confirmation
          confirmed = true;
          triggerButton.click();
        }
      });

      return false;
    });

    // deck share confirmation
    $('button[name="share_deck"]').click(function () {
      // action was already approved
      if (confirmed) {
        return true;
      }

      const triggerButton = $(this);
      const message = 'Are you sure you want to share this deck to other players?';

      // request confirmation
      notification.displayConfirm('Action confirmation', message, (result) => {
        if (result) {
          // pass confirmation
          confirmed = true;
          triggerButton.click();
        }
      });

      return false;
    });

    // import shared deck confirmation
    $('button[name="import_shared_deck"]').click(function () {
      // action was already approved
      if (confirmed) {
        return true;
      }

      // extract target deck name
      const targetDeckId = $('select[name="selected_deck"]').val();
      const targetDeck = $('select[name="selected_deck"] >  option[value="'.concat(targetDeckId, '"]')).text();

      // extract source deck name
      const sourceDeck = $(this).parent().parent().find('a.deck')
        .text();

      const triggerButton = $(this);
      const message = 'Are you sure you want to import '.concat(sourceDeck, ' into ', targetDeck, '?');

      // request confirmation
      notification.displayConfirm('Action confirmation', message, (result) => {
        if (result) {
          // pass confirmation
          confirmed = true;
          triggerButton.click();
        }
      });

      return false;
    });

    // open deck note
    $('a#deck-note').click((event) => {
      event.preventDefault();
      $('#deck-note-dialog').modal();
    });

    // save deck note button
    $('button[name="deck-note-dialog-save"]').click(() => {
      const deckNote = $('textarea[name="content"]').val();

      // check user input
      if (deckNote.length > 1000) {
        notification.displayError('Deck note is too long');
        return;
      }

      const deckId = $('input[name="current_deck"]').val();

      api.saveDeckNote(deckId, deckNote, (result) => {
        // AJAX failed, display error message
        if (result.error) {
          notification.displayError(result.error);
          return;
        }

        // update note button highlight
        if (deckNote === '') {
          // case 1: note is empty (remove highlight)
          $('a#deck-note').removeClass('marked-button');
        } else if (!$('a#deck-note').hasClass('marked-button')) {
          // case 2: note is not empty (add highlight if not present)
          $('a#deck-note').addClass('marked-button');
        }

        $('#deck-note-dialog').modal('hide');
      });
    });

    // clear deck note button
    $('button[name="deck-note-dialog-clear"]').click(() => {
      const deckId = $('input[name="current_deck"]').val();

      api.clearDeckNote(deckId, (result) => {
        // AJAX failed, display error message
        if (result.error) {
          notification.displayError(result.error);
          return;
        }

        // clear input field
        $('textarea[name="content"]').val('');

        // update note button highlight (remove highlight)
        $('a#deck-note').removeClass('marked-button');
      });

      // hide note dialog
      $('#deck-note-dialog').modal('hide');
    });

    // file upload
    $('button[name="import_deck"]').click(() => {
      const uploadedFile = $('input[name="deck_data_file"]');

      // no file was selected
      if (uploadedFile.val() === '') {
        // prompt user to select a file
        uploadedFile.click();
        return false;
      }

      return true;
    });

    // take card from card pool
    $('[data-take-card]').click(function () {
      const cardId = parseInt($(this).attr('data-take-card'), 10);

      return takeCard(cardId);
    });

    // remove card from deck
    $('[data-remove-card]').click(function () {
      const cardId = parseInt($(this).attr('data-remove-card'), 10);

      return removeCard(cardId);
    });
  });
}
