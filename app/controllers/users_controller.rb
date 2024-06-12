class UsersController < ApplicationController
  before_action :set_user, only: [:show, :user_articles, :user_drafts]

  before_action :authorize_user!, only: [:user_drafts]

  def show
    @pending_comments = pending_comments
    @last_actions = last_actions
    @published_articles = published_articles
    @last_five_articles = published_articles.limit(5)
    @unpublished_articles = unpublished_articles
  end

  def user_articles
    @user_articles = published_articles
    render :articles_all
  end

  def user_drafts
    @user_drafts = unpublished_articles
    render :my_drafts
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
  end

  def pending_comments
    Comment.where(article: @user.articles, status: "pending")
  end

  def last_actions
    @user.comments.where(status: "approved").order(created_at: :desc).limit(10)
  end

  def published_articles
    @user.articles.where(published: true).order(created_at: :desc)
  end

  def unpublished_articles
    @user.articles.where(published: false).order(created_at: :desc)
  end

  def authorize_user!
    if current_user != @user
      redirect_to root_path, alert: t("flash.alerts.no_authorize")
    end
  end

end
