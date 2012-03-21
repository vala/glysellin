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
        next_step = @order.next_step
        if @order.next_step == Order::ORDER_STEP_PAYMENT
          OrderCustomerMailer.send_order_created_email(@order).deliver
        end
        redirect_to :action => @order.next_step.to_s, :id => @order.ref
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
      g = PaymentMethod.gateway(params[:goid] ? {:order_id => params[:goid]} : {:raw_post => request.raw_post, :gateway => params[:gateway]})
      
      if g.process_payment! request.raw_post
        OrderCustomerMailer.send_order_paid_email(g.order)
        OrderAdminMailer.send_order_paid_email(g.order)
      end
      
      if g.errors.length > 1
        g.errors.each {|msg| logger.error "[ Glysellin ] Gateway Error : #{msg}"}  
      end
      
      render g.response
    end
  
    def payment_response
      if params[:type]
        @order = nil
        @response_type = params[:type]
      else
        @order = Order.find_by_ref(params[:id])
      end
    end
  end
end
