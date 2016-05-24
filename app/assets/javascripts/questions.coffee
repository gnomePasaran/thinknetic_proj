# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#question-form').show();

  $(document).on 'ajax:success', '#question-form', (data, status, xhr) ->
    $('.edit-question-link').show()
    $('form#question-form').hide()

  $(document).on 'ajax:success', '.question .voting', (e, data, status, xhr) ->
    console.log(xhr.responseJSON.score)
    if xhr.responseJSON.score.score == 'like'
      $('.question .vote-plus').hide()

      $('.question .vote-cancel').show()
      $('.question .vote-minus').show()
    else if xhr.responseJSON.score.score == 'neutral'
      $('.question .vote-cancel').hide()

      $('.question .vote-plus').show()
      $('.question .vote-minus').show()
    else
      $('.question .vote-minus').hide()

      $('.question .vote-plus').show()
      $('.question .vote-cancel').show()
    $('.question .score').replaceWith('<p class="score">' + xhr.responseJSON.total_score + '</p>')
