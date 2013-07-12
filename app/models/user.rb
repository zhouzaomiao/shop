class User < ActiveRecord::Base
  attr_accessible :login, :email, :password, :password_confirmation, :is_activated
  acts_as_authentic

  has_one :shopping_cart
  has_many :comments, :conditions => ["comments.deleted_at is null"], :dependent => :destroy

  validates :login, :presence => true, :length => {:minimum => 4, :maximum => 12, :if => :login?}, :uniqueness => {:if => proc{|u| u.login.present?}}
  validates :email, :presence => true, :length => {:minimum => 4, :maximum => 30, :if => :email?}, :uniqueness => {:if => proc{|u| u.email.present?}}
  
  validates :crypted_password, :presence => true, :length => {:minimum => 4, :maximum => 1022220, :if => :crypted_password?}
  #validates :password_confirmation => true
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】发送邮件时调用处理的action
  def send_signup_mail(url)
    Notifier.signup_mail(self, url).deliver
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】所有用户导出
  def self.export_csv
    pp "=========user_export_csv========="
    #要导出的字段是一个数组，而整个类型是一个Hash类型
    User.all.to_csv(:only => [:login, :email, :crypted_password, :password_salt])
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】导入
  def self.import_db(file)
    results = CsvMapper.import(file.read, :type => :io) do
      start_at_row 1
      map_to User
      [login, email, crypted_password, password_salt]
    end
    if results.present?
      results.each_with_index do |user|
        user.password_confirmation = user.password
        User.transaction() do
          #加!保存不成功的时候会抛出异常
          user.save!
          #如果保存数据出现异常的话，用事物处理可以回滚
          if roll_back_flag
            raise ActiveRecord::Rollback
          end
        end
      end
    end
  end

end
