class Admin::MiddleCategoriesController < Admin::AdminBaseController
  
  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]根据菜单栏来显示所有中分类
  def index
    if request.xhr?
      @all_middle_category = MiddleCategory.where("id > 0").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
      respond_to do |format|
        format.html
        format.js
      end
    else
      @all_middle_category = MiddleCategory.where("id > 0").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
    end
  end
  
  #[引数]big_category_id
  #[返值]@all_middle_category、@big_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中的查询，查询出大分类表中所有的用户到list页面显示
  def list
    @all_middle_category = MiddleCategory.where("big_category_id = ?", params[:id]).paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
    @big_category = BigCategory.find_by_id(params[:id])
  end

  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行创建的时候调用的action
  def new
    #页面要传过去的是一个id和name的hash值，调用下面的方法出来
    pp @all_sort = all_big_category_name
    pp @big_category = BigCategory.find_by_id(params[:big_category])
    pp @middle_category = MiddleCategory.new
  end
  
  #[引数]params[:middle_category][:big_category_id]、params[:middle_category]
  #[返值]@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行创建之后进行调用处理的验证
  def create
    @big_category = BigCategory.find_by_id(params[:middle_category][:big_category_id])
    @middle_category = MiddleCategory.new(params[:middle_category])
    if @middle_category.valid? && @middle_category.save
      redirect_to :action => :list, :id => params[:middle_category][:big_category_id]
    else
      render :action => :new
    end
  end
  
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行编辑之前进行给页面创建一个中分类实例变量
  def edit
    @middle_category = MiddleCategory.find_by_id(params[:id])
    @big_category = @middle_category.big_category
    unless @middle_category.present?
      flash[:message] = "数据不存在,无法编辑！"
      render :controller => "admin/big_category", :action => "list"
    end
  end

  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行修改之后，进行验证和保存的
  def update
    @middle_category = MiddleCategory.find_by_id(params[:id])
    if @middle_category
      @middle_category.middle_category_name = params[:middle_category_name][:name]
      if @middle_category.valid? && @middle_category.save
        flash[:message] = "添加到#{@middle_category.big_category.name} 下的中分类成功"
        redirect_to  :controller => 'admin/middle_category', :action => :list, :id => @middle_category.big_category.id
      else
        @big_category = @middle_category.big_category
        render :controller => "admin/middle_category", :action => :edit, :id => @middle_category.big_category.id
      end
    else
      render :action => "list"
    end
  end
  
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行删除处理的action
  def destroy
    middle_category = MiddleCategory.find_by_id(params[:id])
    if middle_category
      middle_category.destroy
      flash[:message] = "删除#{middle_category.middle_category_name}中分类成功！"
      redirect_to :action => "list", :id => middle_category.big_category.id
    else
      flash[:message] = "删除#{middle_category.middle_category_name}中分类失败！"
      redirect_to :action => "list", :id => middle_category.big_category.id
    end
  end

  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]大分类联动中分类的时候用到的
  def get_mid_cate_test
    request.xml_http_request?	 # 返回true为ajax请求，false为普通请求
    request.xhr?
    pp @sms = MiddleCategory.where("big_category_id = ?", params[:id].to_i)
  end

end
