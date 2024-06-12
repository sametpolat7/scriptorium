class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :edit, :approve, :reject, :destroy]

  before_action :authenticate_user!
  before_action :authorize_user!, only: [:index, :edit, :approve, :reject, :destroy]


  def index
    @user = User.find_by(username: params[:user_username])
    @user_comments = @user.comments.order(updated_at: :desc)

    @articles_w_pending_comments = @user.articles.includes(:comments).where(comments: { status: "pending" })
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to user_comments_path(current_user.username), notice: t("flash.notices.update")
    else
      render :edit
    end
  end

  def destroy
    if @comment.destroy
      redirect_to user_comments_path(current_user.username), notice: t("flash.notices.delete")
    else
      redirect_to user_comments_path(current_user.username), alert: t("flash.alerts.failed")
    end
  end

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @article, notice: t("flash.notices.create_comment")
    else
      redirect_to @article, alert: t("flash.alerts.failed")
    end
  end

  def approve
    if @comment.update(status: "approved")
      redirect_to user_comments_path(current_user.username), notice: t("flash.notices.approve")
    else
      redirect_to user_comments_path(current_user.username), alert: t("flash.alerts.failed")
    end
  end

  def reject
    if @comment.update(status: "rejected")
      redirect_to user_comments_path(current_user.username), alert: t("flash.alerts.reject")
    else
      redirect_to user_comments_path(current_user.username), alert: t("flash.alerts.failed")
    end
  end


  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user!
    case params[:action]
    when "index"
      authorize_comments_view_action
    when "edit"
      authorize_edit_action
    when "approve", "reject"
      authorize_approval_action
    when "destroy"
      authorize_destroy_action
    end
  end

  def authorize_comments_view_action
    if current_user.username != params[:user_username]
      redirect_to root_path, alert: t("flash.alerts.no_authorize")
    end
  end

  def authorize_edit_action
    if current_user != @comment.user
      redirect_to root_path, alert: t("flash.alerts.no_authorize")
    elsif @comment.status == "approved"
      redirect_to root_path, alert: t("flash.alerts.no_permission")
    end
  end

  def authorize_approval_action
    if @comment.article.user != current_user
      redirect_to root_path, alert: t("flash.alerts.no_authorize")
    end
  end

  def authorize_destroy_action
    if current_user != @comment.user && current_user != @comment.article.user
      redirect_to root_path, alert: t("flash.alerts.no_authorize")
    elsif current_user == @comment.user
    elsif current_user == @comment.article.user && @comment.status == "approved"
      redirect_to root_path, alert: t("flash.alerts.no_permission")
    end
  end


  def comment_params
    params.require(:comment).permit(:content, :status)
  end
end
