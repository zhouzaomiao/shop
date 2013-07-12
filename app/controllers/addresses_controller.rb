class AddressesController < UserBaseController
  layout "show_store"

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示用户地址时候调用的action
  def index
    @product_arr = Product.order("sale_count desc").limit(5)
    #根据当前用户找出购物车中所有的商品信息
    @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
    #判断是否找到
    if @shopping_carts.present?
      #购物车中显示的总件数
      @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
      #显示出要填写的地址信息
      @address = Address.new
      #查询本人的选好的商品
      product_count = @shopping_carts.select("sum(quantity*purchase_price) as a").first
      #判断价格是否为0
      if product_count.present? #判断存在
        #总价钱
        @count = product_count.a.to_i
      else
        flash[:message] = "网络异常，请重新操作！"
      end
    else
      @count_quantiry = 0
      render :action => :prompt
    end
  end
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用户创建一个新的的发货地址时进行处理的action
  def create
    @address = Address.new(params[:address])
    @address.user_id = current_user.id
    if @address.valid? && @address.save
      #现在已经付款，要修改shopping_cart中shopping_type标志改为1
      @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      #计算出买出去的商品总价
      product_count = @shopping_carts.select("sum(quantity*purchase_price) as a").first
      count = product_count.a.to_i

      #定义一个变量，用来存在总利润
      cost_count = 0
      @shopping_carts.each do |f|
        cost_count += f.product.cost*f.quantity
      end

      #创建一个账单记录
      purchase = Purchase.new
      purchase.user_id = current_user.id
      purchase.address_id = @address.id
      purchase.total_price = count
      purchase.status = 1
      purchase.protif = count - cost_count#利润
      purchase.updated_at = Time.now
      purchase.save

      #商品购物车中的商品记录标示字段更新
      @shopping_carts.update_all( {:shopping_type => 1, :purchase_id => purchase.id}, "user_id = #{current_user.id} and shopping_type = 0" )
      
      #通过验证这保存成功之后就跳转到下一个页面去付钱
      redirect_to :controller => :purchases, :action => :show, :address_id => @address.id,:id => purchase.id
    else
      #如果输入的有问题：要回显和和提示(model验证)
      @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
      product_count = @shopping_carts.select("sum(quantity*purchase_price) as a").first
      @count = product_count.a.to_i
      render :action => :index
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】当地址为空的时候,进行提示的action
  def prompt
    @product_arr = Product.order("sale_count desc").limit(3)
    @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
    if @shopping_carts.present?
      @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
    else
      redirect_to :controller => :products, :action => :list
    end
  end
end

