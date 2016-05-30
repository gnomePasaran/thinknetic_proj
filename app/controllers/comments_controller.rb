class CommentsController < ActionController::Base
  before_action :authenticate_user!

  before_action :set_commentable, only: [:create]
  before_action :set_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(set_comment)
    @comment.user = current_user

    if commentable_name == 'answers'
      channel = @commentable.question
    else
      channel = @commentable
    end
    respond_to do |format|
      @comment.save
      format.html do
        PrivatePub.publish_to "/questions/#{channel.id}/answer",
            comment: @comment.to_json, commentable: "#{commentable_name.singularize}_#{@commentable.id}"
        render nothing: true
      end
    end
  end

  private

  def set_comment
    params.require(:comment).permit(:body)
  end

  def model_klass
    commentable_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params["#{commentable_name.singularize}_id"])
  end

  def commentable_name
    params[:commentable]
  end
end