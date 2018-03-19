class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :votes
  has_many :comments, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def self.from_omniauth(auth, session)
    session["access_token"] = auth["credentials"]["token"]
    session["access_token_secret"] = auth["credentials"]["secret"]
    find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.email = User.dummy_email(auth)
      user.username = auth["info"]["nickname"]
      user.password = Devise.friendly_token[0, 20]
      user.image_url = auth["info"]["image"].gsub("_normal","")
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end

  private
    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end
end
