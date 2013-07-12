class Product < ActiveRecord::Base
  attr_accessible :name, :num, :count, :cost, :price, :describe, :small_category_id, :recommand, :enabel, :sale_count
  acts_as_paranoid
  belongs_to :small_category
  has_one :product_pictrue, :foreign_key => "obj"
  has_many :shopping_carts , :conditions => ["shopping_carts.deleted_at is null"], :dependent => :destroy
  has_many :comments, :conditions => ["comments.deleted_at is null"], :dependent => :destroy

  attr_accessor :picture

  #validates :name, :presence => true, :length => {:minimum => 1, :maximum => 20, :if => :name?}, :numericality  => {:if => proc{|u| u.tel.present?}}
  
  validates :name, :presence => true, :length => {:minimum => 1, :maximum => 120, :if => :name?}, :uniqueness => {:if => proc{|u| u.name.present?}}
  #不能为空/唯一性/必须是数字
  validates :num, :presence => true, :length => {:minimum => 1, :maximum => 10000, :if => proc{|u| u.num.present?}}, :numericality  => {:if => proc{|u| u.num.present?}}, :uniqueness => {:if => proc{|u| u.num.present?}}
  #不能为空/唯一性/必须是数字
  validates :count, :presence => true, :length => {:minimum => 1, :maximum => 10000, :if => proc{|u| u.count.present?}}, :numericality  => {:if => proc{|u| u.count.present?}}
  
  validates :cost, :presence => true, :numericality  => {:if => proc{|u| u.cost.present?}}, :length => {:minimum => 1, :maximum => 10000, :if => proc{|u| u.cost.present?}}

  validate :cost_must_be_at_least_a_cent, :if => proc{|u| u.cost.present?}

  validates :price, :presence => true, :length => {:minimum => 1, :maximum => 10000, :if => proc{|u| u.price.present?}}, :numericality  => {:if => proc{|u| u.price.present?}}

  validate :price_must_be_at_least_a_cent, :if => proc{|u| u.price.present?}

  #validates  :small_category_id,:numericality => {:only_integer => true} #必须是数字
  validates :describe, :presence => true, :length => {:minimum => 1, :maximum => 10000, :if => proc{|u| u.describe.present?}}


  #  def self.validate(picture)
  #    self.errors.add(:picture, "can not be nil") if picture == nil
  #  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】list查看对应商品的时候调用，返回的是一个sql执行语句
  def get_conn(params)
    conn = [[]]
    if params[:content].present?
      conn[0] << "name like ? and enabel = 1"
      conn << "%#{params[:content]}%"
    end
    if params[:category_id].present?
      a= []
      big_category = BigCategory.find_by_id(params[:category_id])
      middles = big_category.middle_categories
      if middles.present?
        middles.each do |f|
          a << f.small_categories
        end
      end
      conn[0] << "small_category_id in (?)"
      conn << a.flatten.uniq.collect(&:id)
    end
    if params[:middle_category_id].present? 
      middle_category = MiddleCategory.find_by_id(params[:middle_category_id])
      smalls = middle_category.small_categories
      conn[0] << "small_category_id in (?)"
      conn << smalls.flatten.uniq.collect(&:id)
    end
    if params[:small_category_id].present?
      conn[0] << "small_category_id in (?)"
      conn << params[:small_category_id]
    end

    conn[0] << "enabel = 1"
    conn[0] = conn[0].join(' and ')
    return conn
  end

  protected
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】model中的验证方法
  def price_must_be_at_least_a_cent
    if self.price.present?
      errors.add(:price, '价格必须大于0.01') if price.nil? || price < 0.01
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】model中的验证方法
  def cost_must_be_at_least_a_cent
    if self.cost.present?
      errors.add(:cost, '价格必须大于0.01') if cost.nil? || cost < 0.01
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】model中的验证方法
  def self.sale_count_sort
    Product.where("id > 0").select("sale_count")
  end

end
