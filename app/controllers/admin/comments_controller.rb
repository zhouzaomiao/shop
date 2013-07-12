class Admin::CommentsController < Admin::AdminBaseController

  #[引数]商品id
  #[返值]@comments/@product
  #[注意]
  #[作者] zzm 20130610
  #[功能]后台显示出对应商品的所有评论
  def show
    @comments = Comment.where(:product_id => params[:id]).order("updated_at desc").paginate(:page => params[:page], :per_page => 3)
    @product = Product.find_by_id(params[:id])
  end
  
  #[引数]评论id
  #[返值]
  #[注意]
  #[作者] zzm 20130610
  #[功能]后台删除对应的评论，和跳转
  def destroy
    #首先要根据Id在数据库中查找出这条数据
    pp com =  Comment.find_by_product_id(params[:id])
    #判断这个评论是否存在
    if com
      com.destroy
      flash[:message] = "删除#{com.user.login}的评论成功！"
      redirect_to admin_comment_path(:id => com.product_id)
    else
      flash[:message] = "删除评论失败，权限不足！"
      redirect_to admin_comment_path(:id => com.product_id)
    end
  end
end
