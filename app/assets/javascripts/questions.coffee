# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#question-form').show();

  $(document).on 'ajax:success', 'question-form', (data, status, xhr) ->
    $('.edit-question-link').show()
    $('form#question-form').hide()
