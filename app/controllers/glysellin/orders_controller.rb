module Glysellin
  class OrdersController < MainController
    protect_from_forgery :except => :gateway_response
    before_filter :get_customer!
    
    def index
      @orders = current_user.orders
    end
    
    def show
      user_order = Order.where('id = ? AND customer_id = ?', params[:id], @active_customer.id)
      if user_order.length > 0
        @order = user_order.first
      else
        flash[:alert] = t('glysellin.controllers.errors.order_doesnt_exist')
        redirect_to :action => 'index'
      end
    end
    
    def process_order
      @order = Order.from_sub_forms(params[:order])
      # render :text => params.inspect + '<br/><br/>' + @order.items.inspect.gsub(/[<>]/, {'<' => '&lt;', '>' => '&gt;'})
      if @order.save
        redirect_to :action => @order.next_step, :id => @order.ref
      else
        redirect_to :back
      end
    end
    
    def
    
    def cart
    end
        
    def validate_cart  
    end
    
    def fill_addresses
    end
    
    def validate_addresses
    end
  
    def recap
      
    end
    
    def payment
      @order = Order.find_by_ref(params[:id])
    end
    
    def offline_payment
    end
  
    def gateway_response
    end
  
    def payment_response
      @order = Order.find_by_ref(params[:id])
    end
  end
end
