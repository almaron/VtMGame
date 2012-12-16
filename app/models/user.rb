class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates_confirmation_of :password, :message => "should match confirmation", :if => :password
end
