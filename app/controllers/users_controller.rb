class UsersController < UserBaseController
  #layout "user_signup", :include => [:signup]
  layout "show_store", :except => [:signup]
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示所有的订单
  def list_product
    show_shopping_cart
    @purchases_succeed = Purchase.where("user_id = ? and status = 4", current_user.id).order("updated_at desc").paginate(:per_page => 2, :page => params[:page])
    flash[:messge] = "购物成功"
    if request.xhr?
      respond_to do |format|
        #format.html
        format.js
      end
    end

=begin
    if request.xhr?
      pp "---------------------------2"
      render :update do |page|
        pp "---------------------------3"
        text = render :partial => 'purchases_parge'
        pp "---------------------------4"
        page.replace_html "purchases_parge", text
        pp "---------------------------5"
        page.replace_html "promote", ''
        pp "---------------------------6"
        #page << "window.onload();"
      end
    end
=end
  end


  def list_product_ajax
    pp "----------------list_product_ajax"
    pp request.xhr?
    show_shopping_cart
    @purchases_succeed = Purchase.where("user_id = ? and status = 4", current_user.id).order("updated_at desc").paginate(:per_page => 2, :page => params[:page])
  end
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】注册的action、给当前注册用户发送 注册邮件
  def signup
    #render "user_signup"
    @user = User.new(params[:user])
    return if request.get?#如果是get请求，下面的代码就不执行了，然后提交是post请求就会执行下面的代码来发送邮件
    @user.valid? #验证
    if @user.errors.present?
    else
      @user.is_activated = 0 #设置标志，默认的是false,所有后台创建的用户就可以之间登录了
      #@user.reset_persistence_token
      @user.save!
      #获取当前：带端口的主机名"localhost:3000"
      domain = request.host_with_port
      #给用户的超链接地址
      url = "http://"+ domain +"/users/prompt?token=#{@user.persistence_token}"
      @user.send_signup_mail(url) #调用Model方法来进行发送邮件
      flash[:message] = "激活邮件已发送到你的邮箱，请激活！！！"
      pp "--------------------"
      pp current_user
      render :action => :active
    end
  end
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】注册的之后超链接回来处理的action
  def prompt
    user = User.find_by_persistence_token(params[:token])
    if user && user.is_activated == false && user.persistence_token == params[:token] then
      user.is_activated = 1
      user.save!
      flash[:message] = "注册成功！"
    elsif user && user.is_activated == true then
      flash[:message] = "您已经激活过了！"
    else
      flash[:message] = "网络问题，再次激活！"
    end
    redirect_to :controller => 'user_sessions', :action=>'new'
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示对应用户的个人信息
  def show
    @user = User.find(params[:id])
    if current_user.present?
      @big_category_list = BigCategory.where("head_show = 1")
      @product_arr = Product.order("sale_count desc").limit(5)
      shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
      @comments = Comment.where(:product_id => params[:id]).order("updated_at desc").paginate(:page => params[:page], :per_page => 3)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】注册和创建user时调用的action
  def new
    @user = User.new
    return if request.get?#如果是get请求，下面的代码就不执行了，然后提交是post请求就会执行下面的代码来发送邮件
    @user.valid? #验证
    if @user.errors.present?
    else
      @user.first_login = true #设置标志，默认的是false,所有后台创建的用户就可以之间登录了
      #@user.reset_persistence_token
      @user.save
      #获取当前：带端口的主机名"localhost:3000"
      domain = request.host_with_port
      #给用户的超链接地址
      url = "http://"+ domain +"/users/active?token=#{@user.persistence_token}"
      @user.send_signup_mail(url) #调用Model方法来进行发送邮件
      flash[:notice] = "激活邮件已发送到你的邮箱，请激活！！！"
      redirect_to :action => :new
    end
  end

  # GET /users/1/edit
  def edit
    @big_category_list = BigCategory.where("head_show = 1")
    @product_arr = Product.order("sale_count desc").limit(5)
    @user = User.find(params[:id])
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】注册和创建user之后进行验证和保存的action
  def create
    user = User.new(params[:user])
    respond_to do |format|
      if user.save
        format.html { redirect_to :controller => :user_sessions, :action => :new, message: 'User was successfully created.' }
        format.json { render json: user, status: :created, location: user }
      else
        format.html { render action: "new" }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】编辑之后对数据进行验证和处理的action
  def update1
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, message: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】删除user时调用的action和跳转
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】退出
  def logout
    current_user_session.destroy
    flash[:notice] = "退出成功！"
    redirect_to new_user_session_url
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】显示出对应订单的所有商品
  def show_products
    @big_category_list = BigCategory.where("head_show = 1")
    #显示排行榜用的数据
    @product_arr = Product.order("sale_count desc").limit(5)
    #查询出账单中的数据
    shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
    #总数量
    @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
    purchase = Purchase.find_by_id(params[:id])
    @shopping_carts = ShoppingCart.where("user_id = ? and purchase_id = ?", current_user.id, purchase.id)
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】给用户买了的商品进行评论
  def comment_manage
    @shopping_cart_product = ShoppingCart.where("user_id = ? and product_id = ? and shopping_type = 1", current_user.id, params[:id]).first
    @comments = Comment.find_by_product_id(params[:id])
    @comment = Comment.new
  end

  private
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】公共部分的变量的调用
  def show_shopping_cart
    @big_category_list = BigCategory.where("head_show = 1")
    middle_category = MiddleCategory.where("big_category = ?", params[:category_id])
    #查询出这个用户共有多少件商品
    if current_user.present?
      shopping_carts = ShoppingCart.where("user_id = ? and shopping_type = 0", current_user.id)
      @count_quantiry = shopping_carts.select("sum(quantity)as b").first.b.to_i
    end
    @product_arr = Product.order("sale_count desc").limit(5)
  end
end
