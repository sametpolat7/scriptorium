class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :status, :published, :comments, :tags

  def content
    object.content.body
  end

  def status
    object.published ? "Published" : "Draft"
  end

  def published
    object.created_at
  end

  def comments
    object.comments.where(status: "approved").map(&:content)
  end

  def tags
    object.tags.pluck(:name)
  end
end
