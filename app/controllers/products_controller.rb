class ProductsController < UserBaseController
  layout "show_store", :except => [:search]
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示详细商品信息
  def show
    @big_category_list = BigCategory.where("head_show = 1")
    Product.sale_count_sort
    #查询出要显示的商品
    @product = Product.find_by_id(params[:id])
    @comments = Comment.where(:product_id => params[:id]).order("updated_at desc").paginate(:page => params[:page], :per_page => 3)
    @comment = Comment.new
    #查询出这个用户共有多少件商品
    #判断下当前用户是否存在：存在就显示购物车的数量，不存在的就为0
    if current_user.present?
      shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i 
    end
    @product_arr = Product.order("sale_count desc").limit(5)
  end
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用来显示出所有商品的
  def list
    middle_category = MiddleCategory.where("big_category = ?", params[:category_id])
    if params[:category_id].present?
      big = BigCategory.find_by_id(params[:category_id])
      @middle_name = big.middle_categories
    end
    if params[:middle_category_id].present?
      middle = MiddleCategory.find_by_id(params[:middle_category_id])
      @small_name = middle.small_categories
    end
    
    product = Product.new
    #用来检索的，调用model来生成sql语句
    condition = product.get_conn(params)
    @products = Product.where(condition).paginate(:page => params[:page], :per_page => 12)
  rescue
    flash[:message] = "你要找的数据没有找到！"
    redirect_to :action => :list
  end
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用来处理检索的action
  def search
    @big_category_list = BigCategory.where("head_show = 1")
    product = Product.new
    #用来检索的，调用model来生成sql语句
    condition = product.get_conn(params)
    @products = Product.where(condition).paginate(:page => params[:page], :per_page => 3)
    #查询出这个用户共有多少件商品
    if current_user.present?
      shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
    end
    @product_arr = Product.order("sale_count desc").limit(5)
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】页面联动大分类调用中分类的时候调用
  def get_mid_cate
    request.xml_http_request?	 # 返回true为ajax请求，false为普通请求
    request.xhr?
    @sms = MiddleCategory.where("big_category_id = ?", params[:id])
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】页面联动中方类调用小分类的时候调用
  def get_sma_cate
    request.xml_http_request?	 # 返回true为ajax请求，false为普通请求
    request.xhr?
    @sms = SmallCategory.where("middle_category_id = ?", params[:id])
  end

  private
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】公共部分的变量的调用
  def show_shopping_cart
    @big_category_list = BigCategory.where("head_show = 1")
    middle_category = MiddleCategory.where("big_category = ?", params[:category_id])
    #查询出这个用户共有多少件商品
    if current_user.present?
      shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
    end
    @product_arr = Product.order("sale_count desc").limit(5)
  end
end
