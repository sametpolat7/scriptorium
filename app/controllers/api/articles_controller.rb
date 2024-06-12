class Api::ArticlesController < ApplicationController
  def index
    @articles = Article.where(published: true)
    render json: pretty_json(@articles, each_serializer: ArticleSerializer)
  end

  def show
    @article = Article.find(params[:id])
    render json: pretty_json(@article, serializer: ArticleSerializer)
  end

  private

  def pretty_json(resource, options = {})
    serialized_resource = ActiveModelSerializers::SerializableResource.new(resource, options).as_json
    JSON.pretty_generate(serialized_resource)
  end
end
