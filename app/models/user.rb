class User < ApplicationRecord
  has_secure_password
  before_save :downcase_email

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, length: { maximum: 255 }
  validates :username, presence: true, length: { maximum: 255 }
  validates :password, length: { minimum: 6 }, presence: true

  private

  def downcase_email
    self.email.downcase!
  end
end
