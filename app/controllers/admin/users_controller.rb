class Admin::UsersController < Admin::AdminBaseController
  layout 'admin'
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  # 管理员对用户管理的首页面，查询出用户表中所有的用户到list页面显示
  def list
    @users = User.where("id > 0").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对用户管理的具体用户，根据id查询出具体用户显示出来
  def show
    @user = User.find_by_id(params[:id])
  end
  
  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]创建一个实例变量传到前台去
  def new
    @user = User.new
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]查询出一个实例变量传到前台去编辑
  def edit
    @user = User.find_by_id(params[:id])
    if @user.blank?
      redirect_to "/admin/admin_sessions/user_list"
    end
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]根据form表单提交上来的数据，用model来验证看是否通过，通过这保存和给出提示语，不通过这返回new页面，给予model验证的提示语
  def create
    @user = User.new(params[:user])
    if @user.valid? && @user.save
      #在list页面给予提示信息
      flash[:message] = "添加用户#{@user.login}成功"
      redirect_to :action => "list"
    else
      #使用model来提示错误信息
      render action: "new"
    end
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]根据form表单提交上来的数据，用model来验证看是否通过，通过这更新和给出提示语
  def update
    @user = User.find_by_id(params[:id])
    if @user
      if @user.valid? && @user.update_attributes(params[:user])
        flash[:message] = "#{@user.login}用户数据更新成功!"
        redirect_to list_admin_users_url
      else
        render :action => "edit"
      end
    else
      redirect_to "/admin/admin_sessions/new"
    end
  end
  
  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能] 根据传过来的id查找出用，然后删除
  def destroy
    @user = User.find_by_id(params[:id])
    if @user
      @user.destroy
      flash[:message] = "#{@user.login}用户数据删除成功!"
      redirect_to list_admin_users_url 
    else
      redirect_to "/admin/admin_sessions/login"
    end
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]根据传过来的数组id查找出用，然后根据sql中的in来进行批量删除
  def batch_delete
    id = params[:id].join(",")
    #会发出DELETE FROM `users` WHERE (id in (43,44)这样的sql语句
    User.delete_all("id in (#{id})")
    flash[:message] = "批量删除用户数据删除成功!"
    redirect_to list_admin_users_url
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]进行数据的全部导出
  def export
    @users = User.all
    respond_to do |format|
      format.html
      format.xml{ render :xml => @users }
      format.csv{send_data User.export_csv, :type => 'text/csv', :filename => "user_#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"}
    end
  end

  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能] 进行数据的全部导出
  def import_user
    return if request.get?
    user_file = params[:file]
    if user_file.present?
      User.import_db(user_file)
      flash[:message] =  '导入文件成功！'
      redirect_to ("list/admin/users"), notice: 'User was successfully updated.'
    else
      flash[:message] =  '你没有选择要导入的文件！'
      render action: "import_user"
    end
  end
end
