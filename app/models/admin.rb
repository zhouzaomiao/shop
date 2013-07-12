class Admin < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :login, :email, :password, :password_confirmation
  acts_as_authentic
end
