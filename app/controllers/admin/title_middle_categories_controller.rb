class Admin::TitleMiddleCategoriesController < Admin::AdminBaseController

  #[引数]
  #[返值]@all_middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]标题栏中点击时调用的action
  def index
    @all_middle_category = MiddleCategory.where("id >= 1").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
  end

  #[引数]
  #[返值]@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]标题栏中点击时创建中分类调用action
  def new
    @middle_category = MiddleCategory.new
  end
  
  #[引数]
  #[返值]@big_category、@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]创建大分类进行数据验证和跳转的action
  def create
    @big_category = BigCategory.find_by_id(params[:middle_category][:big_category_id])
    @middle_category = MiddleCategory.new(params[:middle_category])
    if @middle_category.valid? && @middle_category.save
      redirect_to :action => :index
    else
      render :action => :new
    end
  end

  #[引数]
  #[返值]@all_sort、@middle_category、@big_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]编辑中分类时调用的action
  def edit
    pp @all_sort = all_big_category_name
    @middle_category = MiddleCategory.find_by_id(params[:id])
    @big_category = @middle_category.big_category
    unless @middle_category.present?
      flash[:message] = "数据不存在,无法编辑！"
      render :controller => "admin/title_categories", :action => "index"
    end
  end

  #[引数]
  #[返值]@middle_category、@big_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]编辑中分类之后调用的action
  def update
    @middle_category = MiddleCategory.find_by_id(params[:id])
    if @middle_category
      @middle_category.middle_category_name = params[:middle_category][:middle_category_name]
      if @middle_category.valid? && @middle_category.save
        flash[:message] = "更新到#{@middle_category.big_category.name} 下的中分类#{@middle_category.middle_category_name}成功"
        redirect_to  :controller => 'admin/title_middle_categories', :action => :index, :id => @middle_category.big_category.id
      else
        @big_category = @middle_category.big_category
        render :controller => "admin/title_middle_categories", :action => :edit, :id => @middle_category.big_category.id
      end
    else
      render :action => "index"
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
      redirect_to :action => "index"
    else
      flash[:message] = "删除#{middle_category.middle_category_name}中分类失败！"
      redirect_to :action => "index"
    end
  end
end
