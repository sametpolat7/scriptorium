require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(email: "user@example.com", username: "testuser", password: "password")
  end

  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "should not be valid without an email" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "username should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "should have many articles" do
    assert_respond_to @user, :articles
  end

  test "should have many comments" do
    assert_respond_to @user, :comments
  end

end
