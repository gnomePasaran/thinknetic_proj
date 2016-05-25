# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'ajax:success', '.voting', (e, data, status, xhr) ->
    elem = $(e.target).data('entity-type') + '_' + xhr.responseJSON.id
    if xhr.responseJSON.score.score == 'like'
      $('#votable-' + elem + ' .vote-plus').hide()

      $('#votable-' + elem + ' .vote-cancel').show()
      $('#votable-' + elem + ' .vote-minus').show()
    else if xhr.responseJSON.score.score == 'dislike'
      $('#votable-' + elem + ' .vote-minus').hide()

      $('#votable-' + elem + ' .vote-plus').show()
      $('#votable-' + elem + ' .vote-cancel').show()
    else
      $('#votable-' + elem + ' .vote-cancel').hide()

      $('#votable-' + elem + ' .vote-plus').show()
      $('#votable-' + elem + ' .vote-minus').show()
    $('#votable-' + elem + ' .score').replaceWith('<p class="score">' + xhr.responseJSON.total_score + '</p>')