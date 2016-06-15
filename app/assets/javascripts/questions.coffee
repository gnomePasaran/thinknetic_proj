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

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('#questions tbody')
      .prepend('<tr><td class="title"><a href="/questions/' + question.id + '">' + question.title + '</a></td></tr>')

  questionId = $('.question').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answer' , (data, channel) ->
    # question = $.parseJSON(data['question'])
    # console.log question
    console.log data.question
    # console.log JST
    console.log JST["templates/questions/question"]({data.question})
    $('.question').replaceWith(JST["templates/questions/question"]({data.question}))
