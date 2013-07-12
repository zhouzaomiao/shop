#coding: utf-8
Shopping::Application.routes.draw do 
  mount Ckeditor::Engine => '/ckeditor'

  resources :users do
    collection do
      get "logout"
      get "list_product"
      get "show_products"
      match "signup"
      get "prompt"
      get "comment_manage"
      get "list_product_ajax"
    end
  end
  resources :user_sessions, :comments
  resources :purchases do
    collection do
      match "my_indent"
      get "confirm_product"
      get "cancel_purchase"
      get "return_purchase"
      match "my_indent_ajax"
    end
  end
  resources :addresses do
    collection do
      get "prompt"
    end
  end
  resources :products do
    collection do
      match "list"
      get "get_mid_cate"
      get "get_sma_cate"
      get "search"
    end
  end
  resources :shopping_carts do
    collection do
      match "add_cart_success"
      get "add_cart"
      get "total_prices"
      get "down_total_prices"
      get "quantity_count"
      get "input_quantity"
      get "add_to_bill"
      match "add_address"
      get "prompt"
    end
  end

#下面的都是admin下面的路由配置
  namespace :admin do
    resources :users do
      collection do
        match "list"
        post 'batch_delete'
        get 'export'
        match "import_user"
      end
    end

    resources  :admin_sessions do
      collection do
        get "logout"
        get "login"
      end
    end

    resources :big_categories do
      collection do
        get 'list'
      end
    end

    resources :middle_categories do
      collection do
        get 'list'
        get "get_mid_cate_test"
      end
    end

    resources :title_middle_categories

    resources :small_categories do
      collection do
        get 'list'
        get "get_mid_cate_test"
      end
    end

    resources :title_small_categories

    resources :products do
      collection do
        get 'list'
        get 'up_frame'
      end
    end

    resources :product_pictrues do
      collection do
        post "preview_image"
        put "preview_image"
      end
    end

    resources :purchases do
      collection do
        get "send_product"
        match "price_collect"
        post "total_price"
        match "ajax_link"
      end
    end
    resources :comments 
 
  end

  #  resources :products do
  #    collection do
  #      get "show_product"
  #    end
  #  end


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'products#list'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
