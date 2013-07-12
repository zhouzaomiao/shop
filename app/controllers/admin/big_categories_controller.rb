class Admin::BigCategoriesController < Admin::AdminBaseController

  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]管理员对大分类的查询，查询出大分类表中所有的用户到list页面显示
  def list
    #利用where语句来进行查找出所有的大分类(where：进行分页的话，利用all不可以？)
    if request.xhr?
      @all_big_category = BigCategory.where("id >= 1").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
      respond_to do |format|
        format.html
        format.js
      end
    else
      @all_big_category = BigCategory.where("id >= 1").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
    end
  end

  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]创建大分类的、创建一个实例变量传到页面上去
  def new
    @big_category = BigCategory.new
  end

  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]页面上创建了一个大分类保存的时候,
  def create
    @big_category = BigCategory.new(params[:big_category])
    if @big_category.valid? && @big_category.save
      flash[:message] = "添加大分类成功"
      redirect_to :action => :list
    else
      render :action => :new
    end
  end

  #[引数]大分类id
  #[返值]@big_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]编辑大分类
  def edit
    #首先要从数据库中查找出要编辑的大分类
    @big_category = BigCategory.find_by_id(params[:id])
    #判断下查找出来的是否为空(防止别人修改url来进行破坏程序)，同事给出提示和跳转到list页面
    if !@big_category
      flash[:message] = "数据不存在,无法编辑！"
      redirect_to  :controller => 'admin/big_categories', :action => :list
    end
  end
  #[引数]大分类id
  #[返值]@big_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]对编辑后的大分类进行验证和保存
  def update
    #首先从数据库中去查找编辑的大分类
    @big_category = BigCategory.find_by_id(params[:id])
    #判断先编辑的大分类现在在数据库是否存在
    if @big_category
      @big_category.name = params[:big_category][:name]
      #在数据保存之前要进行model验证、同时也要对数据进行保存是否成功进行判断
      if @big_category.valid? && @big_category.save
        #如果数据保存成功、则跳转到list显示页面、并且给出提示语
        flash[:message] = "大分类#{@big_category.name}更新成功！"
        redirect_to  :controller => 'admin/big_categories', :action => :list
      else
        #如果不成功，这渲染到编辑页面去
        render :action => :edit
      end
    else
      #如果没有找到更新的对象，这跳转到list显示页面，并给出提示语
      flash[:message] = "要更新的数据损害，请重写操作"
      redirect_to  :controller => 'admin/big_categories', :action => :list
    end
  end

  #[引数]大分类id
  #[返值]@big_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]删除大分类
  def destroy
    #首先要查找出要操作的数据来
    big_category = BigCategory.find_by_id(params[:id])
    #如果数据是否存在进行判断
    if big_category
      #如果存在，这进行删除操作，并且给出提示语，和跳转到list页面去
      big_category.destroy
      flash[:message] = "删除#{big_category.name}大分类成功！"
      redirect_to :action => :list
    else
      #如果没有查找到数据，跳转到list页面，这给出提示语告诉用户
      flash[:message] = "要删除的数据不存在，大分类删除失败！"
      redirect_to :action => :list
    end
  end
end

