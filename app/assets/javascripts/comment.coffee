# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).on 'click', '.new-comment-link', (e) ->
    e.preventDefault();
    $(e.target).hide();
    commentableID = $(this).data('commentable')
    $('#' + commentableID + ' #new-comment-form').show();

  questionId = $('.question').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/answer' , (data, channel) ->
    comment = $.parseJSON(data['comment'])
    commentable = data['commentable']
    $('#' + commentable + '.comment-template .comments').append('<p id="' + comment.id + '" class="comment">' + comment.body + '</p>')
    $('.new_comment #comment_body').val('')
