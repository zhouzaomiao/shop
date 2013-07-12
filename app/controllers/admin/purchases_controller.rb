class Admin::PurchasesController < Admin::AdminBaseController

  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]所有订单显示的
  def index
    find_purchase
    if request.xhr?
      respond_to do |format|
        format.js
      end
    end
  end

  def ajax_link
    find_purchase
    if request.xhr?
      respond_to do |format|
        format.js
      end
    end
  end

  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]发货的处理action
  def send_product
    purchase = Purchase.find_by_id(params[:id])
    pp "-------------------------------------------1"
    if purchase.present?
      #修改订单的状态
      purchase.status = 3
      #用来给卖出去的货物时，商品的字段累加
      products = ShoppingCart.where("purchase_id = ?",purchase.id )#.update_all({:sale_count => sele_count + quantiry})
      products.each do |f|
        @product = Product.find_by_id(f.product_id)
        #销售了多少产品
        @product.sale_count =  @product.sale_count.to_i + @product.count.to_i
        #商品本身的数量要减去买了的数量
        @product.count.to_i >= f.quantity.to_i
        if @product.count.to_i >= f.quantity.to_i
          @product.count = @product.count.to_i - f.quantity.to_i
        else
          flash[:message] = "商品数量不足！"
          pp "-------------------------------------------"
          pp request.xhr?
          if request.xhr?
            respond_to do |format|
              # format.html
              pp "------------------------request========================"
              format.js
            end
          end
          #return
        end
        @product.update_attributes!({:sale_count => @product.sale_count, :count => @product.count})
        @product.save
        purchase.save
      end
      @purchases = Purchase.where("id > 0 ").paginate(:page => params[:page], :per_page => 16)
      flash[:message] = "第#{purchase.id}号订单发货成功！"
      pp "-------------------------------------------3"
      pp request.xhr?
      if request.xhr?
        respond_to do |format|
          # format.html
          pp "------------------------request========================"
          format.js
        end
      end
      #redirect_to :action => :index
    else
      @purchases = Purchase.where("id > 0 ").paginate(:page => params[:page], :per_page => 16)
      flash[:message] = "第#{purchase.id}号订单发货失败,数据不存在"

      pp request.xhr?
      if request.xhr?
        respond_to do |format|
          # format.html
          pp "------------------------request========================"
          format.js
        end
      end
      #render :action => :index
    end

   
  end

  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]处理营业额的action
  def price_collect
    start_time = Time.new.beginning_of_week
    over_time = Time.new.end_of_week
    purchases = Purchase.where("created_at between ? and ? ",start_time,over_time)
    @price_const = purchases.select("sum(total_price) as a").first.a.to_i
    @profit_const = purchases.select("sum(protif) as b").first.b.to_i
    if request.post?
      if params[:price][:count].to_i == 2
        start_time = Time.new.beginning_of_month()
        over_time = Time.new.end_of_month()
        purchases = Purchase.where("created_at between ? and ? ",start_time,over_time)
        @price_const = purchases.select("sum(total_price) as a").first.a.to_i
        @profit_const = purchases.select("sum(protif) as b").first.b.to_i
      else if(params[:price][:count].to_i == 3)
          start_time = Time.new.beginning_of_quarter()
          over_time = Time.new.end_of_quarter()
          purchases = Purchase.where("created_at between ? and ? ",start_time,over_time)
          @price_const = purchases.select("sum(total_price) as a").first.a.to_i
          @profit_const = purchases.select("sum(protif) as b").first.b.to_i
        else if(params[:price][:count].to_i == 4)
            start_time = Time.new.beginning_of_year()
            over_time = Time.new.end_of_year()
            purchases = Purchase.where("created_at between ? and ? ",start_time,over_time)
            @price_const = purchases.select("sum(total_price) as a").first.a.to_i
            @profit_const = purchases.select("sum(protif) as b").first.b.to_i
          else if(params[:price][:count].to_i == 1)
              start_time = Time.new.beginning_of_week
              over_time = Time.new.end_of_week
              purchases = Purchase.where("created_at between ? and ? ",start_time,over_time)
              @price_const = purchases.select("sum(total_price) as a").first.a.to_i
              @profit_const = purchases.select("sum(protif) as b").first.b.to_i
            end
          end
        end
      end
      render :action => :price_collect
    end
  end
  #[引数]
  #[返值]
  #[注意]
  #[作者] zzm 20130523
  #[功能]取消订单处理的action
  def destroy
    purchase = Purchase.find_by_id(params[:id])
    if purchase
      purchase.destroy
      flash[:message] = "第#{purchase.id}号订单取消成功！"
      redirect_to :action => :index
    else
      flash[:message] = "第#{purchase.id}号订单取消失败,数据不存在"
      render :action => "index"
    end
  end
  
  private
  #[引数]
  #[返值]@purchases、@count、@purchases_pending、@purchases_sent、@purchases_succeed、
  #       @purchases_return、@purchases_return_succeed、@purchases_return_fail、@purchases_cancel
  #[注意]
  #[作者] zzm 20130523
  #[功能]查询出公共的一些实例变量
  def find_purchase
    purchase = Purchase.new
    params["admin_id"] = current_admin.id
    #查询出要显示的结果
    condition = purchase.get_conn(params)
    if Purchase.where(condition).length < 3
      @purchases = Purchase.where(condition).order("id desc")
    else
      @purchases = Purchase.where(condition).order("id desc").paginate(:page => params[:page], :per_page => 2)
    end
    #查询出所有账单总数
    purchases_counts = Purchase.where("status in (?)", [1,3,4,5,6,7,8] )
    @count = purchases_counts.length #查询出所有的总数0
    @purchases_pending = 0 #查询出待处理总数1
    @purchases_sent = 0 #查询出已发货总数3
    @purchases_succeed = 0#成功4
    @purchases_return = 0 #查询出取消的总数5
    @purchases_return_succeed =0 #6
    @purchases_return_fail = 0 #7
    @purchases_cancel = 0 #8

    purchases_counts.each do |f|
      if f.status == 1
        @purchases_pending += 1
      end
      if f.status == 3
        @purchases_sent += 1
      end
      if f.status == 4
        @purchases_succeed += 1
      end
      if f.status == 5
        @purchases_return += 1
      end
      if f.status == 6
        @purchases_return_succeed += 1
      end
      if f.status == 7
        @purchases_return_fail += 1
      end
      if f.status == 8
        @purchases_cancel += 1
      end
    end
  end
 
end
