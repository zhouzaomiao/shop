class ProductPictrue < Attachment
  
  has_attached_file :avatar,
    :styles => { :medium => "300x300", :thumb => "150x150" },
    :default_url => "/images/:style/missing.png"
  
  belongs_to :product, :foreign_key => "obj"
end
