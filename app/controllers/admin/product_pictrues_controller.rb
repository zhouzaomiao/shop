class Admin::ProductPictruesController < ApplicationController
  #[引数]
  #[返值]@all_sort/@big_category/@middle_category
  #[注意]
  #[作者] zzm 20130523
  #[功能]预览图片
  def preview_image
    file_name = UUIDTools::UUID.random_create.to_s  
    file = params[:product][:product_pictrue]
    #获得原图片的后缀名
    if file
      ext_name =  file.original_filename.split('.').second
      File.open("#{Rails.root}/public/images/pictrues/#{file_name}.#{ext_name}", "wb") do |f|
        f.puts file.read
      end
      @path = "/images/pictrues/#{file_name}.#{ext_name}"
    else
      flash[:message] = "图片资源不存在、请重新选择！"
    end
  end
end
