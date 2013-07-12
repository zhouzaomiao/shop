class CommentsController < UserBaseController
  layout "show_store"

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】登陆用户创建评论
  def create
    #首先要判断用户是否登录
    if current_user.present?
      pur = []
      #Purchase.where("user_id = ? and product")
      shopping_carts = ShoppingCart.where("user_id = ? and product_id = ? and shopping_type = 1", current_user.id, params[:comment][:product_id])
      shopping_carts.each do |f|
        pur = Purchase.where("id = ? and user_id = ?", f.purchase_id, current_user.id)
      end
      #判断是否买了这件商品
      if pur.present?
        comm = Comment.where("user_id = ? and product_id = ?", current_user.id, params[:comment][:product_id])       
        #判断是否评论过了
        if !comm.present?
          com = Comment.new
          com.user_id = current_user.id
          com.product_id = params[:comment][:product_id]
          com.comment = params[:comment][:user_content]
          com.score = params[:score]
          if com.valid?&&com.save
            flash[:message] = "添加评论成功！"
            redirect_to :controller => :users, :action => :comment_manage, :id => params[:comment][:product_id]
          else
            #@shopping_cart_product = ShoppingCart.where("user_id = ? and product_id = ? and shopping_type = 1", current_user.id, params[:comment][:product_id]).first
            #@comments = Comment.find_by_product_id(params[:comment][:product_id])
            flash[:message] = "评论失败，内容不能为空！"
            redirect_to :controller => :users, :action => :comment_manage, :id => params[:comment][:product_id]
          end
        else
          flash[:message] = "您 已经评论过了！！！"
          redirect_to :controller => :users, :action => :comment_manage, :id => params[:comment][:product_id]
        end
      else
        flash[:message] = "货物已经下架！"
        redirect_to :controller => :users, :action => :comment_manage, :id => params[:comment][:product_id]
      end
    else
      flash[:message] = "您还没有登陆，没有权限评论"
      redirect_to :controller => :users, :action => :comment_manage, :id => params[:comment][:product_id]
    end
  end
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】对评论进行编辑
  def edit
    pp @shopping_cart_product = ShoppingCart.where("user_id = ? and product_id = ? and shopping_type = 1", current_user.id, params[:id]).first
    pp @comments = Comment.find_by_product_id(params[:id])
    pp @comment = @comments
    #render :controller => :users, :action => :comment_manage
  end

  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】自己删除本评论
  def update
    @comment = Comment.find_by_product_id(params[:comment][:product_id])
    if @comment
      @comment.product_id = params[:comment][:product_id]
      @comment.comment = params[:comment][:comment]
      @comment.score = params[:score]
      if @comment.valid? and @comment.save
        flash[:message] = "更新数据成功！"
        redirect_to :controller => :users, :action => :comment_manage, :id => params[:comment][:product_id]
      else
        @shopping_cart_product = ShoppingCart.where("user_id = ? and product_id = ? and shopping_type = 1", current_user.id, params[:comment][:product_id]).first
        @comments = Comment.find_by_product_id(params[:comment][:product_id])
        render :controller => :comments, :action => :edit, :id => params[:comment][:product_id]
      end
    else
      flash[:message] = "数据错误，请重新操作！！！"
      render :controller => :comments, :action => :edit, :id => params[:comment][:product_id]
    end
  end

  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】自己删除本评论
  def destroy
    #首先要根据Id在数据库中查找出这条数据
    com =  Comment.find_by_id(params[:id])
    #判断这个评论是否存在
    if com
      com.destroy
      flash[:message] = "删除评论成功！"
      redirect_to comment_manage_users_path(:id => com.product_id)
    else
      flash[:message] = "删除评论失败，权限不足！"
      redirect_to comment_manage_users_path(:id => com.product_id)
    end
  end


end
