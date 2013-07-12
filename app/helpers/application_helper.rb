module ApplicationHelper
  
  def will_paginate_remote(paginator, options={})
    function = options.delete(:after)
    update = options.delete(:update)
    url = options.delete(:url)
    str = will_paginate(paginator, options)
=begin
    if str != nil
      str = str.gsub(/href="(.*?)"/) do
        "href=\"#\" onclick=\"jQuery.ajax('#{(url ? url + $1.sub(/[^\?]*/, '') : $1)}',{
          method: 'get',
          dataType: 'html',
          success: function(data){
              alert('---------');
              $('##{update}').html(data);

          }
        })\""
      end.html_safe
    end
=end
    str.scan(/href="(.*?)"/).flatten.uniq.each do |a|
      test_url = url ? url + a.sub(/[^\?]*/, '') : a
      str.gsub!("href=\"#{a}\"") do
        "href=\"#\" onclick=\"jQuery.ajax('#{test_url}',{
          method: 'get',
          dataType: 'html',
          success: function(data){
              $('##{update}').html(data);
          }
        })\""
      end
    end
    str.html_safe
  end
end
