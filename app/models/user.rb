class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable,
         :omniauthable, :omniauth_providers => [:faebook]

  has_and_belongs_to_many :events
  has_many :events_created, foreign_key: "creator_id", class_name: 'Event'
  has_many :comments

  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "64x64>" }, :default_url => "missing.png" 

  validates_presence_of :nome
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_size :avatar, :less_than => 1.megabytes

  scope :admins, -> { where(admin: true) }

  def my_level      # gambiarras, depois tu melhora Marcelo ;)
    if (0..100).include?(self.pontuacao)
      ['Saidinho', 'fa fa-rocket']            # <i class="fa fa-hand-peace-o"></i>
    elsif (101..300).include?(self.pontuacao)
      ['Baladeiro', 'fa fa-bullhorn']           # <i class="fa fa-bullhorn"></i>
      
    elsif (301..900).include?(self.pontuacao)
      ['Baladeiro Supremo', 'fa fa-rocket']   # <i class="fa fa-rocket"></i>
       
    else
      ['Rei do Camarote', 'fa fa-diamond']     # <i class="fa fa-diamond"></i>
    end
  end

  def point_of_presence
    increment_point 10
  end

  def point_of_comment
    increment_point 2
  end

  def point_for_create_event
    increment_point 50
  end
  
  # methods for retrieving the user from the omniauth from authentication
  
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid).first_or_create) do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
  end
  end
  
  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.vaild?
      end
    else
      super
    end
  end
  
  def password_required?
    super && provider.blank?
    
  end
  private
  def increment_point(valor)
    self.pontuacao += valor
    self.save
  end

end
