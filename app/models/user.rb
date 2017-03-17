class User < ActiveRecord::Base
  include GuidPrimaryKey

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  attr_accessor :password # This needed for a weird devise bug when only using omniauth

  def self.from_omniauth(auth)
    if not auth.info.email.end_with? '@playfirst.com'
      return
    end

    user = User.where(auth.slice(:provider, :uid)).first_or_create
    user.name = auth.info.name
    user.email = auth.info.email
    user.save
    user
  end
end
