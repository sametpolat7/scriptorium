require "test_helper"

class ArticleTest < ActiveSupport::TestCase

  test "should not save article without title" do
    article = Article.new
    assert_not article.save, "Saved the article without a title"
  end

  test "title should not exceed 140 characters" do
    article = Article.new(title: "a" * 141)
    assert_not article.save, "Saved the article with a title longer than 140 characters"
  end

  test "should set default content if content is blank" do
    article = Article.new(title: "Test Article", content: "")
    article.save
    assert_equal "Content will be here!", article.content.body.to_plain_text, "Default content was not set correctly"
  end

  test "should return only published articles" do
    published_article = articles(:published_article)
    unpublished_article = articles(:unpublished_article)

    assert_includes Article.published, published_article, "Published article was not included in the published scope"
    refute_includes Article.published, unpublished_article, "Unpublished article was included in the published scope"
  end

  test "should return articles matching the query" do
    article1 = articles(:ruby_article)
    article2 = articles(:rails_article)
    article3 = articles(:javascript_article)

    assert_includes Article.search("Ruby"), article1, "Ruby article was not found in search results"
    assert_includes Article.search("Rails"), article2, "Rails article was not found in search results"
    refute_includes Article.search("React"), article3, "JavaScript article was incorrectly found in search results for React"
  end
end
