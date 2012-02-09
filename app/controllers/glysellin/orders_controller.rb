module Glysellin
  class OrdersController < ApplicationController
    protect_from_forgery :except => :gateway_response
    
    def index
      @orders = @active_customer.orders
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
    
    def process
      
    end

    
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
    
    def offline_payment
    end
  
    def gateway_response
    end
  
    def payment_response
    end
  end
end
