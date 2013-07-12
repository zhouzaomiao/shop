module UserBaseHelper
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】前台菜单的list页面中控制显示用到的
  def category_user_staly
    if params[:big_show].present?
      return "display:biock"
    else
      return "display:none"
    end
  end
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】前台菜单的list页面中控制显示用到的
  def category_big_staly
    if params[:category_id].present?
      return "display:biock"
    else
      return "display:none"
    end
  end
  #【引数】
  #【返值】
  #【注意】
  #【作者】 zzm 20130523
  #【功能】前台菜单的list页面中控制显示用到的
  def category_middle_staly
    if params[:middle_category_id].present?
      return "display:biock"
    else
      return "display:none"
    end
  end
end
