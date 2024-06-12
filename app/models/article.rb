class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 }

  before_validation :set_default_content, if: -> { content.blank? }

  has_rich_text :content

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  scope :published, -> { where(published: true) }

  def self.search(query)
    query = query.downcase

    if query.start_with?("tag:")
      tag_query = query[4..].strip.downcase
      joins(:tags).where("lower(tags.name) LIKE ?", "%#{tag_query}%")
    else
      where("lower(title) LIKE :query OR
            id IN (SELECT record_id FROM action_text_rich_texts WHERE record_type = 'Article' AND lower(body) LIKE :query) OR
            id IN (SELECT article_id FROM article_tags WHERE tag_id IN (SELECT id FROM tags WHERE lower(name) LIKE :query))",
            query: "%#{query}%")
    end
  end

  private

  def set_default_content
    self.content = "Content will be here!"
  end
end
