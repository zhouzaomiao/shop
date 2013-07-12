class Admin::ProductsController < Admin::AdminBaseController
  #[引数]
  #[返值]@products
  #[注意]
  #[作者] zzm 20130523
  #[功能]后台管理商品时，查询出所有的商品
  def list
    @products = Product.where("id > 0").paginate(:page => params[:page], :per_page => APP_CONFIG[:page][:per_page])
  end

  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]后台创建商品时，创建一个实例变量
  def new
    @product = Product.new
  end
  
  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]创建商品时处理的action
  def create
    #首先用的是form_for表单手机数据的，而product中是在没有pictrue字段的
    #所有要利用hash中的方法删除
    @picture_product = params[:product].delete("product_pictrue")
    #利用product来接收对象
    @product = Product.new(params[:product])
    @product.up_time = Time.new
    #首先要进行model来验证，然后看图片是否存在
    if @product.valid? && @picture_product
      product_pictrue = ProductPictrue.new
      product_pictrue.avatar = @picture_product
      #图片要在商品保存之后在保存
      Product.transaction do
        begin
          if @product.save!
            #obj是attachment是外键
            product_pictrue.obj = @product.id
            product_pictrue.save!
            flash[:message] = "第#{@product.num}号产品#{@product.name}添加成功！"
            redirect_to :action => :list
          else
            flash[:message] = "由于网络问题，保存不成功！请重新操作"
            render :action => "new"
          end
        rescue Exception => e
          raise ActiveRecord::Rollback
        end
      end
    else
      #向product中添加错误信息的提示
      if !@picture
        @product.errors.add_on_blank(:picture)
      end
      #这里的提示语用model来验证提示
      render :action => "new"
    end
  end
  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]商品编辑的action
  def edit
    #要利用find来找出要操作的商品、和小分类的id
    @product = Product.find_by_id(params[:id])
    @small_category_id = params[:small_category_id]
    pp @pictrue = ProductPictrue.find_by_obj(@product.id)
  end
  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]显示商品详细
  def show
    #利用find从数据库中查找出来
    @product = Product.find_by_id(params[:id])
  end
  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]编辑之后进入这个action进行处理
  def update
    #首先要利用传过来的id参数进行商品到数据库中去查找
    @product = Product.find_by_id(params[:id])
    @product_pictrue = ProductPictrue.find_by_obj(params[:id])
    pictrue_attribute = params[:product].delete("product_pictrue")
    #判断这个要更新的商品是否存在
    if @product_pictrue #判断是否存在
      @product_pictrue.avatar = pictrue_attribute
    else
      @product_pictrue = ProductPictrue.new
      @product_pictrue.obj = @product.id
      @product_pictrue.avatar = pictrue_attribute
    end

    if @product
      #判断更新字段是否正常执行
      Product.transaction do
        begin
          if @product.valid? && @product.update_attributes(params[:product])
            @product_pictrue.save
            flash[:message] = "第#{@product.num}号产品#{@product.name}数据更新成功！"
            redirect_to  :controller => 'admin/products', :action => :list
          else
            flash[:message] = "第#{@product.num}号产品#{@product.name}数据更新失败！"
            @pictrue = ProductPictrue.find_by_obj(@product.id)
            render :action => :edit
          end
        rescue Exception => e
          raise ActiveRecord::Rollback
        end
      end
    else
      flash[:message] = "您要更新的数据不存在！"
      render :action => :list
    end
  end
  
  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]删除商品的时候处理的action进行处理
  def destroy
    #首先利用id参数进行数据库查找
    product = Product.find_by_id(params[:id])
    #根据查找上来的product进行判断是否存在
    if product
      product.destroy
      flash[:message] = "第#{product.num}号产品#{product.name}删除成功！"
      redirect_to :controller => :products, :action => :list
    else
      flash[:message] = "第#{product.num}号产品#{product.name}删除失败,数据不存在"
      render :action => "list"
    end
  end
  #[引数]
  #[返值]@product
  #[注意]
  #[作者] zzm 20130523
  #[功能]上架和下架操作时候处理的action进行处理
  def up_frame
    #首先根据id参数今天查找要操作的商品
    product = Product.find_by_id(params[:id])
    #看商品是否存在
    if product.present?
      #查看商品的上架和下架的标示字段enabel，下面是商品上架操作
      unless product.enabel
        #如果商品本来就是下架的，现在要上架就要改变标示的值
        product.enabel = 1
        product.up_time = Time.new
        #设置操作完了，要进行保存
        if product.save
          flash[:message] = "第#{product.num}号产品#{product.name}上架成功!!!"
          redirect_to :action => "list"
        end
      else
        #这里进行的是下架操作，同事下面是要进行改变的一些数据
        product.enabel = 0
        product.up_time = nil
        if product.save
          flash[:message] = "第#{product.num}号产品#{product.name}下成功!!!"
          redirect_to :action => "list"
        end
      end
    else
      flash[:message] = "产品不存在,请正确操作"
      redirect_to :action => "list"
    end
  end

end
