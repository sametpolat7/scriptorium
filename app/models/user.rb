class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      username = data['nickname'] || data['email'].split('@').first
      user = User.create(
        email: data['email'],
        username: username,
        password: Devise.friendly_token[0, 20]
      )
    end
    user
  end
end
