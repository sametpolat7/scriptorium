class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy, :increment_like_count]

  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]


  def index
    @published_articles = Article.where(published: true).order(created_at: :desc)
  end

  def show
    @approved_comments = @article.comments.where(status: 'approved')
    if user_signed_in?
      @user_pending_comments = @article.comments.where(status: 'pending', user: current_user)
    end
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      @article.tags = find_or_create_tags
      redirect_to @article, notice: t("flash.notices.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      @article.tags = find_or_create_tags
      redirect_to @article, notice: t("flash.notices.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: t("flash.notices.delete")
  end

  def increment_like_count
    @article.increment!(:like_count)
    redirect_to @article
  end

  def search
    @search_results = Article.published.search(params[:query])
  end


  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :content, :published, tag_ids: [])
  end

  def authorize_user!
    if current_user != @article.user
      redirect_to @article, alert: t("flash.alerts.no_authorize")
    end
  end

  def find_or_create_tags
    tags = params[:article][:tags].split(',').map(&:strip).uniq
    tags.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
  end

end
