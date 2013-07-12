class Purchase < ActiveRecord::Base
  # attr_accessible :title, :body
  acts_as_paranoid
  belongs_to :address
  has_many :shopping_carts, :conditions => ["shopping_carts.deleted_at is null"], :dependent => :destroy

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】查找对应订单时调用，返回的是一个sql语句
  def get_conn(params)
    conn = [[]]
    if params[:user_id].present?
      if params[:status_id] == nil
        conn[0] << "status in (1,3,5) and user_id = #{params[:user_id]}"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 1
        conn[0] << "status in (1) and user_id = #{params[:user_id]}"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 3
        conn[0] << "status in (3) and user_id = #{params[:user_id]}"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 5
        conn[0] << "status in (5) and user_id = #{params[:user_id]}"
        conn[0] = conn[0].join(' and ')
      end
    else
      if params[:status_id] == nil
        conn[0] << "status in (1,3,4,5,6,7,8)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 1
        conn[0] << "status in (1)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 3
        conn[0] << "status in (3)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 4
        conn[0] << "status in (4)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 5
        conn[0] << "status in (5)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 6
        conn[0] << "status in (6)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 7
        conn[0] << "status in (7)"
        conn[0] = conn[0].join(' and ')
      end
      if params[:status_id].to_i == 8
        conn[0] << "status in (8)"
        conn[0] = conn[0].join(' and ')
      end
    end
    

    
    return conn
  end
  
  #【引数】
  #【返值】一个二维数组
  #【注意】
  #【作者】 zzm 20130523
  #【功能】是给营业额调用的一个方法
  def self.time_count
    time_count=[["本周",1],["本月",2],["本季度",3],["本年",4]]
  end
end
