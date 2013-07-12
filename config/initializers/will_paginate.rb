# To change this template, choose Tools | Templates
# and open the template in the editor.

module Will_paginate
  WillPaginate::ViewHelpers.pagination_options[ :class] = "yourclass"
  WillPaginate::ViewHelpers.pagination_options[:previous_label] = "上一页"
  WillPaginate::ViewHelpers.pagination_options[:next_label] = "下一页"
end
