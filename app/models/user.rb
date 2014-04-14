class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :twitter] 
   
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :uid, :provider, :token
  # attr_accessible :title, :body
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  #debugger
    
    #@fb_friends = FbGraph::User.me(auth.credentials.token).friends
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
    #debugger
    user = User.create(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         password: Devise.friendly_token[0,20],
                         token: auth.credentials.token
                         
                         )                  
    end
    user 
  end
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    #debugger
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    #debugger
    unless user
    user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         password:Devise.friendly_token[0,20],
                         token:auth.credentials.token
                         
                         ) 
    #debugger                                        
    end
    user
  end
  
  
    def email_required?
      false
    end
  
end
