class CommentsController < ActionController::Base
  before_action :authenticate_user!

  before_action :set_commentable, only: [:create]
  before_action :set_comment, only: [:create]
  after_action  :publicate_comment, only: [:create]

  respond_to :json

  def create
    @comment = @commentable.comments.create(set_comment.merge(user_id: current_user.id))
    @channel = @commentable.question if commentable_name == 'answers'
    @channel ||= @commentable

    respond_with @channel
  end

  private

  def publicate_comment
    PrivatePub.publish_to "/questions/#{@channel.id}/answer",
        comment: @comment.to_json, commentable: "#{commentable_name.singularize}_#{@commentable.id}" if @comment.errors.empty?
  end

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