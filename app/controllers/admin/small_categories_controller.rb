class Admin::SmallCategoriesController < Admin::AdminBaseController
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]根据菜单栏来显示所有中分类
  def index
    if request.xhr?
      @all_small_category = SmallCategory.where("id > 0").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
      respond_to do |format|
        pp format
        format.html
        format.js
      end
    else
      @all_small_category = SmallCategory.where("id > 0").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
    end
  end
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中的查询，查询出大分类表中所有的用户到list页面显示
  def list
    @all_small_category = SmallCategory.find_all_by_middle_category_id(params[:id])
    @middle_category = MiddleCategory.find_by_id(params[:id])
  end
  #[引数]params[:id]
  #[返值]@small_category/@middle_category/@middle_categories
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行创建的时候调用的action
  def new
    #大分类和中分类是以hash的形式传到到页面上去
    @small_category = SmallCategory.new

    #@all_sort = all_middle_category_name
    @middle_category = MiddleCategory.find_by_id(params[:id])

    #查出大分类对应下的所有的中分类，传递到页面用来默认值
    @middle_categorys = MiddleCategory.where("big_category_id = ?", @middle_category.big_category_id).collect {|bs| [bs.middle_category_name, bs.id]}
  end

  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行创建之后进行调用处理的验证
  def create
    @small_category = SmallCategory.new
    @small_category.small_category_name = params[:small_category]
    @small_category.middle_category_id = params[:middle_category_id]
    if @small_category.valid? && @small_category.save
      redirect_to :controller => :small_categories, :action => :list, :id => params[:middle_category_id]
    else
      @middle_category = MiddleCategory.find_by_id(params[:middle_category_id])
      @middle_categorys = MiddleCategory.where("big_category_id = ?", @middle_category.big_category_id).collect {|bs| [bs.middle_category_name, bs.id]}
      render :action => :new
    end
  end


  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行编辑之前进行给页面创建一个中分类实例变量
  def edit
    @small_category = SmallCategory.find_by_id(params[:id])
    @middle_category = @small_category.middle_category
    @middle_categories = MiddleCategory.where("big_category_id = ?", @middle_category.big_category_id).collect {|bs| [bs.middle_category_name, bs.id]}
    if @small_category == nil
      flash[:message] = "数据不存在,无法编辑！"
      redirect_to  :controller => 'admin/small_categories', :action => :list, :id => @middle_category.id
    end
  end
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行修改之后，进行验证和保存的
  def update
    @small_category = SmallCategory.find_by_id(params[:id])
    if @small_category
      @small_category.small_category_name = params[:small_category_name][:name]
      if @small_category.valid? && @small_category.save
        flash[:message] = "数据#{@small_category.small_category_name}更新成功！"
        @small_category.middle_category_id
        redirect_to  :controller => 'admin/small_categories', :action => :list, :id => @small_category.middle_category.id
      else
        @middle_category = @small_category.middle_category
        @middle_categorys = MiddleCategory.where("big_category_id = ?", @middle_category.big_category_id).collect {|bs| [bs.middle_category_name, bs.id]}
        render :action => :edit, :id => @small_category.id#edit_admin_small_category_path(@small_category.id)
      end
    else
      flash[:message] = "您要更新的数据不存在！"
      redirect_to  :controller => 'admin/small_category', :action => :list
    end
  end
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对中分类进行删除处理的action
  def destroy
    small_category = SmallCategory.find_by_id(params[:id])
    if small_category
      small_category.destroy
      flash[:message] = "#{small_category.small_category_name}小分类删除成功！"
      @all_small_category = SmallCategory.find_all_by_middle_category_id(small_category.middle_category_id)
      @middle_category = small_category.middle_category
      render :action => :list
    else
      flash[:message] = "小分类删除失败！"
      render :action => :list
    end
  end
  #[引数]
  #[返值]@sms
  #[注意]
  #[作者] zzm 20130523
  #[功能]大分类联动中分类的时候用到的
  def get_mid_cate_test
    request.xml_http_request?	 # 返回true为ajax请求，false为普通请求
    request.xhr?
    pp params[:id]
    pp @sms = SmallCategory.where("middle_category_id = ?", params[:id])
  end
end
