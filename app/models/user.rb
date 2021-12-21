class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :notes, dependent: :destroy

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    binding.pry
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email) do |user|
      user.password = SecureRandom.urlsafe_base64
    end 
  end
end
