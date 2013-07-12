class Admin::AdminSessionsController < Admin::AdminBaseController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => :destroy
  layout "user_login"

  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]管理员登陆的action，创建一个实例变量给前台
  def login
    #Admin.create({:login => "admin" ,:password_confirmation => "admin" , :password => "admin" , :email => "123456@qq.com"})
    @admin_session = AdminSession.new
  end
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]管理员登陆进行处理和跳转的actin
  def create
    @admin_session = AdminSession.new(params[:admin_session])
    if @admin_session.save
      flash[:notice] = "管理员已登录!"
      session[:name]  = @admin_session.login
      redirect_to list_admin_products_url
    else
      flash[:notice] = "用户名或密码错误！"
      render :action => :login
    end
  end
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]管理员登陆退出时要调用的一个action来进行session的销毁
  def destroy
    current_admin_session.destroy
    redirect_to new_user_session_url
  end
  #[引数]
  #[返值]@admin_session
  #[注意]
  #[作者] zzm 20130610
  #[功能]管理员登陆退出时调用的action
  def logout
    current_admin_session.destroy
    flash[:notice] = "退出成功！"
    redirect_to login_admin_admin_sessions_path
  end
end
