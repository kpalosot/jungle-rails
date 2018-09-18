class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true,
            uniqueness: {
              case_sensitive: false
            }
  validates :password, presence: true, confirmation: true, length: { minimum: 3 }
  validates :password_confirmation, presence: true

  has_secure_password

  def self.authenticate_with_credentials(email, password)
    @user = User.find_by_email(email.strip.downcase)
    @user = (@user && @user.authenticate(password)) ? @user : nil
  end
end
