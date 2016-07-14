class CommentsController < ApplicationController
  before_action :load_commentable

  def index
    @commentable = Group.find(params[:group_id])
    @comments = @commentable.comments.order(created_at: :desc)
  end

  def new
    @comment = @commentable.comments.new
    render layout: false
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user
    if @comment.save
      @comment.create_activity key: 'comment.create', owner: current_user
      redirect_to @commentable, notice: "Kommentar erstellt."
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_commentable
    klass = [Group].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find_by(id: params["#{klass.name.underscore}_id"])
  end
end
