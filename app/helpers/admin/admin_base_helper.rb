module Admin::AdminBaseHelper
  
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】后台的菜单保持不动的方法
  def category_staly
    if params[:controller] == "admin/big_categories" || params[:controller] == "admin/middle_categories"  || params[:controller] == "admin/small_categories" || params[:controller] == "admin/title_middle_categories"  || params[:controller] == "admin/title_small_categories"

      return "display:biock"
    else
      return "display:none"
    end
  end
end
