class Admin::AdminBaseController < ApplicationController
  layout 'admin'
  #功能：必须登录了之后才可以进行操作
  before_filter :login_filter, :except =>["login", "create"]


  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]管理员时判断登陆了没有
  def login_filter
    if !current_admin.present?
      redirect_to login_admin_admin_sessions_path
    end
  end
  
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]查找当前所有的大分类
  def all_big_category_name
    arr_big_category = BigCategory.all
    arr_big_category = {}

    arr_big_category.each do |arr_big_category|
      arr_big_category[arr_big_category.name]= arr_big_category.id
    end
    arr_big_category
  end
  
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]查找当前所有的中分类
  def all_middle_category_name
    arr_middle_category = MiddleCategory.all
    all_middle_sort = {}

    all_middle_sort.each do |arr_big_category|
      all_middle_sort[arr_big_category.name]= arr_big_category.id
    end
    all_middle_sort
  end

  private
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]管理员session
  def current_admin_session
    return @current_admin_session if defined?(@current_admin_session)
    @current_admin_session = AdminSession.find
  end
  
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]可以获取当前管理员
  def current_admin
    return @current_admin if defined?(@current_admin)
    @current_admin = current_admin_session && current_admin_session.admin
  end

  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]可以判断当前管理员是否存在
  def require_admin
    unless current_admin
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_admin_session_url
      return false
    end
  end

  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]现在用户不在跳到注册页面去注册
  def require_no_admin
    if current_admin
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end
  
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]
  def store_location
    #session[:return_to] = request.request_uri
    session[:return_to] = request.url
  end

  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]返回到默认的url里面去
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
end
