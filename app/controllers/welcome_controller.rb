class WelcomeController < ApplicationController

  def index
    @published_articles = Article.where(published: true).order(created_at: :desc).limit(5)
  end

end
