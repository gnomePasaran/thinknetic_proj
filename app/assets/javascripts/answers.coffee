# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $(document).on 'ajax:success', '.edit_answer_form', (data, status, xhr) ->
    $('.edit-answer-link').show()
    $('.edit_answer_form').hide()

  $(document).on 'ajax:success', '.answers', (e, data, status, xhr) ->
    console.log(xhr.responseJSON.score)
    if xhr.responseJSON.score.score == 'like'
      $('#answer-' + xhr.responseJSON.id + ' .vote-plus').hide()

      $('#answer-' + xhr.responseJSON.id + ' .vote-cancel').show()
      $('#answer-' + xhr.responseJSON.id + ' .vote-minus').show()
    else if xhr.responseJSON.score.score == 'neutral'
      $('#answer-' + xhr.responseJSON.id + ' .vote-cancel').hide()

      $('#answer-' + xhr.responseJSON.id + ' .vote-plus').show()
      $('#answer-' + xhr.responseJSON.id + ' .vote-minus').show()
    else
      $('#answer-' + xhr.responseJSON.id + ' .vote-minus').hide()

      $('#answer-' + xhr.responseJSON.id + ' .vote-plus').show()
      $('#answer-' + xhr.responseJSON.id + ' .vote-cancel').show()
    $('#answer-' + xhr.responseJSON.id + ' .score').replaceWith('<p class="score">' + xhr.responseJSON.total_score + '</p>')