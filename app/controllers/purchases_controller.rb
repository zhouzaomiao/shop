class PurchasesController < UserBaseController
  layout "show_store"

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示出账单
  def show
    @big_category_list = BigCategory.where("head_show = 1")
    #显示排行榜用的数据
    @product_arr = Product.order("sale_count desc").limit(5)
    #查询出账单中的数据
    shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
    #总数量
    @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
    #收件人地址
    #@address = Address.find_by_id(params[:address_id])
    purchase = Purchase.find_by_id(params[:id])
    @address = purchase.address
    @shopping_carts = ShoppingCart.where("user_id = ? and purchase_id = ?", current_user.id, purchase.id)
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示订单
  def my_indent
    show_shopping_cart
    #查找出要处理的订单
    #@purchases = Purchase.where("user_id = ? and status in (?)", current_user.id, [1,3,5,6,7] ).order("id desc").paginate(:page => params[:page], :per_page => 3)
    #purchase = Purchase.new
    #首先判断是前台还是后台查询
    if current_user.present?
      #往params注入当前用户的id
      find_purchase
    end
    pp "-------------------------request"
    pp request.xhr?
    if request.xhr?
      respond_to do |format|
        # format.html
        pp "------------------------request========================"
        format.js
      end
    end
  end

  def my_indent_ajax
    pp "---------------------------ajax"
    show_shopping_cart
    #查找出要处理的订单
    #@purchases = Purchase.where("user_id = ? and status in (?)", current_user.id, [1,3,5,6,7] ).order("id desc").paginate(:page => params[:page], :per_page => 3)
    #purchase = Purchase.new
    #首先判断是前台还是后台查询
    if current_user.present?
      #往params注入当前用户的id
      find_purchase
    end
    if request.xhr?
      respond_to do |format|
        # format.html
        pp "--------------ajax----------request========================"
        format.js
      end
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】删除账单内的商品
  def destroy
    shopping_cart_product_exist = ShoppingCart.find_by_product_id(params[:id])
    if shopping_cart_product_exist
      shopping_cart_product_exist.destroy
      flash[:message] = "删除#{shopping_cart_product_exist.product.name}商品成功！"
      @shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      product_count = ShoppingCart.where("user_id = ?",current_user.id).select("sum(quantity*purchase_price) as a").first
      if product_count.present?#存在
        @count = product_count.a.to_i
        @count_quantiry = @shopping_carts.select("sum(quantity)as b").first.b.to_i
        
        find_purchase

      else
        flash[:message] = "数据不存在！"
      end
      redirect_to :controller => :addresses, :action => :index
    else
      flash[:message] = "删除#{shopping_cart_product_exist.product.name}商品失败！"
      @show_big_category = BigCategory.where("head_show = ?", 1)
      @shopping_carts = ShoppingCart.where("user_id = ?", current_user.id)
      redirect_to :controller => :addresses, :action => :index
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】确认收货
  def confirm_product
    pp ""
    @big_category_list = BigCategory.where("head_show = 1")
    @purchase = Purchase.find_by_id(params[:id])
    if @purchase
      @purchase.status = 4
      if @purchase.save
        flash[:message] = "第#{@purchase.id}号账单，确认收货成功！"
        find_purchase
        redirect_to list_product_users_path
      else
        flash[:message] = "由于网络问题，请重新操作！"
        render :action => my_indent
      end
    else
      flash[:message] = "您的订单不存在，请重新操作！"
      render :my_indent
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】取消订单，退货
  def return_purchase
    @big_category_list = BigCategory.where("head_show = 1")
    @purchase = Purchase.find_by_id(params[:id])
    if @purchase
      @purchase.status = 5
      if @purchase.save!
        flash[:message] = "第#{@purchase.id}账单，取消订单成功！"
        find_purchase
        redirect_to my_indent_purchases_path(:id => @purchase)
      else
        flash[:message] = "由于网络问题，请重新操作！"
        render :action => my_indent
      end
    else
      flash[:message] = "您的订单不存在，请重新操作！"
      render :my_indent
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】取消退货
  def cancel_purchase
    @big_category_list = BigCategory.where("head_show = 1")
    @purchase = Purchase.find_by_id(params[:id])
    if @purchase
      @purchase.status = 1
      if @purchase.save
        flash[:message] = "第#{@purchase.id}账单，取消退货成功！"
        find_purchase
        redirect_to my_indent_purchases_path(:id => @purchase)
      else
        flash[:message] = "由于网络问题，请重新操作！"
        render :action => my_indent
      end
    else
      flash[:message] = "您的订单不存在，请重新操作！"
      render :my_indent
    end
  end

  private
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】公共部分的变量这里调用
  def find_purchase
    pp "---------------------------------------find_purchase"
    purchase = Purchase.new
    params["user_id"] = current_user.id
    #查询出要显示的结果
    condition = purchase.get_conn(params)
    @purchases = Purchase.where(condition).order("created_at desc").paginate(:page => params[:page], :per_page => 2)
    #查询出所有账单总数
    purchases_counts = Purchase.where("user_id = ? and status in (?)", current_user.id, [1,3,5] )
    @count = purchases_counts.length #查询出所有的总数
    @purchases_pending = 0 #查询出待处理总数
    @purchases_sent = 0 #查询出已发货总数
    @purchases_return = 0 #查询出取消的总数

    purchases_counts.each do |f|
      if f.status == 1
        @purchases_pending += 1
      end
      if f.status == 3
        @purchases_sent += 1
      end
      if f.status == 5
        @purchases_return += 1
      end
    end
  end
end
