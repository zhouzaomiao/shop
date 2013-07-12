class UserBaseController < ApplicationController
  helper_method :current_user_session, :current_user
  before_filter :show_shopping_cart


 
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】计算所有的商品数量
  def show_shopping_cart
    @big_category_list = BigCategory.where("head_show = 1")
    #查询出这个用户共有多少件商品
    if current_user.present?
      shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
    end
    @product_arr = Product.order("sale_count desc").limit(5)
  end
  #下面是插件的一些方法 可以用在方法回来过滤
  private
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用户session
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】可以获取当前用户
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用户是否存在
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】现在用户不在跳到注册页面去注册
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】现在用户不在跳到注册页面去注册
  def store_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.url
  end
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】返回到默认的url里面去
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
