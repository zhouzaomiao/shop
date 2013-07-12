#这个模块完成了用户的登入和登出功能
class UserSessionsController < UserBaseController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => :destroy

  layout "user_login"
  #【引数】
  #【返值】@user_session
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用户登陆时候调用的action
  def new
    @user_session = UserSession.new
  end
  
  #【引数】
  #【返值】@user_session
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用户登陆之后进行处理的action。验证和跳转
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:message] = "登录成功!"
      redirect_to list_products_path
    else
      render :action => :new
    end
  end

  #【引数】
  #【返值】@user_session
  #【注意】
  #【作者】 zzm 20130523
  #【功能】注销用户
  def destroy
    current_user_session.destroy
    flash[:notice] = "退出成功！"
    redirect_to new_user_session_url
  end
end
