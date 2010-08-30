class User

  include DataMapper::Resource
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # :registerable
  devise :database_authenticatable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,  :timeoutable


  property :id, Serial


  has n, :memberships
  has n, :projects, :through => :memberships, :model => Yogo::Project
  has n, :roles,    :through => :memberships
  belongs_to :system_role

  validates_confirmation_of :password
  
end
