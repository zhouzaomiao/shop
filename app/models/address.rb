class Address < ActiveRecord::Base
  attr_accessible :name, :tel, :address
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 20, :if => :name?}
  validates :tel, :presence => true, :length => {:minimum => 6, :maximum => 11, :if => proc{|u| u.tel.present?}}, :numericality  => {:if => proc{|u| u.tel.present?}}
  validates :address, :presence => true

  has_one :purchase
#  def test
#    pp "*************************************"
#    pp self.tel
#   pp self.tel?
#   self.tel?
#  end
end
