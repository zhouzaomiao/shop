class ShoppingCartsController < UserBaseController
  layout "show_store"

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】用来显示当前用户所有选择好的商品
  def index
    @big_category_list = BigCategory.where("head_show = 1")
    @product_arr = Product.order("sale_count desc").limit(5)
    @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
    if @shopping_carts.present?
      #购物车中显示的总件数
      @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
      #查询本人的选好的商品
      product_count = @shopping_carts.select("sum(quantity*purchase_price) as a").first
      #判断价格是否为0
      if product_count.present? #判断存在
        #总价钱
        @count = product_count.a.to_i
        #render :text => @count
      else
        flash[:message] = "数据不存在！"
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
  #【功能】添加到购物车中的action
  def add_cart
    @big_category_list = BigCategory.where("head_show = 1")
    @product_arr = Product.order("sale_count desc").limit(5)
    @product = Product.find_by_id(params[:id])
    if @product && @product.enabel
      #判断这个用户有没有没这件商品，由于查找出来的是一个数组，所以要加一个first来取出对象
      shopping_cart_product_exist = ShoppingCart.where("user_id = ? and product_id = ? and shopping_type = 0", current_user.id, @product.id).first
      if shopping_cart_product_exist
        #存储当前商品的价格
        shopping_cart_product_exist.purchase_price = @product.price
        #数量加1
        shopping_cart_product_exist.quantity += 1
      else
        #没有的话就创建一条新记录
        shopping_cart_product_exist = ShoppingCart.new
        shopping_cart_product_exist.product_id = @product.id
        shopping_cart_product_exist.purchase_price = @product.price
        shopping_cart_product_exist.quantity = 1
        #添加标志0是在购物车中的
        shopping_cart_product_exist.shopping_type = 0
        shopping_cart_product_exist.user_id = current_user.id
      end
      #保存
      if shopping_cart_product_exist.save
        #查询出还没有付款的所有商品
        @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
        product_count = @shopping_carts.select("sum(quantity*purchase_price) as a").first
        @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
        #首先要判断下查找出来的数据内容存在
        @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
        flash[:message] = "第#{@product.num}号商品#{@product.name}添加到购物车成功"
      end
    else
      flash[:message] = "此货物已经下架"
      render :conrroller => :product, :action => :list
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】账单显示action
  def add_to_bill
    @big_category_list = BigCategory.where("head_show = 1")
    #根据当前用户找出购物车中所有的商品信息
    @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
    #判断是否找到
    if @shopping_carts.present?
      #购物车中显示的总件数
      @count_quantiry = 0
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
      flash[:message] = "您购物车中所有货物都已经下架，请你继续选择你喜欢的商品！"
      render :conrroller => :product, :action => :list
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】这个action没有用到、自己要多看下问题是出在哪里
  def add_cart_success
    @product = Product.find_by_id(params[:id])
    #判断商品存在或者是否下架
    if @product && @product.enabel
      #判断这个用户有没有没这件商品，由于查找出来的是一个数组，所以要加一个first来取出对象
      shopping_cart_product_exist = ShoppingCart.where("user_id = ? and product_id = ?", current_user.id, @product.id).first
      if shopping_cart_product_exist
        #存储当前商品的价格
        shopping_cart_product_exist.purchase_price = @product.price
        #
        shopping_cart_product_exist.quantity += 1
      else
        shopping_cart_product_exist = ShoppingCart.new
        shopping_cart_product_exist.product_id = @product.id
        shopping_cart_product_exist.purchase_price = @product.price
        shopping_cart_product_exist.quantity = 1
        shopping_cart_product_exist.user_id = current_user.id
      end
      if shopping_cart_product_exist.save
        @shopping_carts = ShoppingCart.where("user_id = ?", current_user.id)
        product_count = @shopping_carts.select("sum(quantity*purchase_price) as a").first
        @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
        #首先要判断下查找出来的数据内容存在
        if product_count.present? #判断存在
          @count = product_count.a.to_i
          #render :text => @count
        else
          flash[:message] = "数据不存在！"
        end
        flash[:message] = "第#{@product.num}号商品#{@product.name}添加到购物车成功"
      end
    else
      flash[:message] = "此货物已经下架"
      render :conrroller => :product, :action => :show
    end
    @show_big_category = BigCategory.where("head_show = ?", 1)
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】删除购物车中选中的商品
  def destroy
    shopping_cart_product_exist = ShoppingCart.where("product_id = ? and user_id = ?", params[:id], current_user.id).first
    if shopping_cart_product_exist
      shopping_cart_product_exist.destroy
      flash[:message] = "删除#{shopping_cart_product_exist.product.name}商品成功！"
      @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      product_count = ShoppingCart.where("user_id = ?",current_user.id).select("sum(quantity*purchase_price) as a").first
      if product_count.present?#存在
        @count = product_count.a.to_i
        @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
        #render :text => @count
      else
        flash[:message] = "数据不存在！"
      end
      redirect_to :action => :index
    else
      flash[:message] = "删除#{shopping_cart_product_exist.product.name}商品失败！"
      @show_big_category = BigCategory.where("head_show = ?", 1)
      @shopping_carts = ShoppingCart.where("user_id = ?", current_user.id)
      redirect_to :action => :add_cart_success
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】加1事件处理
  def total_prices
    qty = Product.find_by_id(params[:id]).count
    if params[:qty].to_i <= qty
      cart = ShoppingCart.where("product_id = ? and user_id = ?", params[:id], current_user.id).first
      cart.quantity += 1
      if cart.save
        product_count = ShoppingCart.where("user_id = ? and shopping_type = 0",current_user.id).select("sum(quantity*purchase_price) as a").first
        if product_count.present?#存在
          #算出总的价钱
          @count = product_count.a.to_i
          render :text => @count
        else
          flash[:message] = "数据不存在！"
        end
      else
        flash[:message] = "由于网络问题、操作失败，请重新操作"
      end
    else
      flash[:message] = "商品数量不足"
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】减1事件处理
  def down_total_prices
    cart = ShoppingCart.where("product_id = ? and user_id = ?", params[:id], current_user.id).first
    cart.quantity -= 1
    if cart.save
      flash[:message] = "修改商品数量成功"
    else
      flash[:message] = "由于网络问题、操作失败，请重新操作"
    end
    product_count = ShoppingCart.where("user_id = ? and shopping_type = 0",current_user.id).select("sum(quantity*purchase_price) as a").first
    if product_count.present?#存在
      @count = product_count.a.to_i
      render :text => @count
    else
      flash[:message] = "数据不存在！"
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】输入数量处理
  def input_quantity
    #qty = Product.find_by_id(params[:id]).count
    shopping_cart = ShoppingCart.where("product_id = ? and user_id = ?", params[:product_id], current_user.id).first
    #首先判断是否存在
    if shopping_cart.present?
      shopping_cart.quantity = params[:quantity]
      shopping_cart.save
    end

    product_count = ShoppingCart.where("user_id = ? and shopping_type = 0",current_user.id).select("sum(quantity*purchase_price) as a").first
    if product_count.present?#存在
      pp @count = product_count.a.to_i
      render :text => @count
    else
      flash[:message] = "数据不存在！"
    end
  end

end
