module Glysellin
  class OrdersController < MainController
    protect_from_forgery :except => :gateway_response
    before_filter :init_order!

    def index
      @orders = Order.from_customer(current_user)
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

    def create_from_cart
      order = Order.create_from_cart(current_cart, current_user)

      if order.save
        redirect_to :action => order.next_step, :id => order.ref
      else
        redirect_to :back
      end
    end

    def process_order
      @order = Order.from_sub_forms(params[:glysellin_order], params[:id])

      if @order.save
        next_step = @order.next_step
        if @order.next_step == ORDER_STEP_PAYMENT
          if Glysellin.send_email_on_check_order_placed && @order.paid_by_check?
            OrderAdminMailer.send_check_order_created_email(@order).deliver
          end
          OrderCustomerMailer.send_order_created_email(@order).deliver
        end
        redirect_to :action => @order.next_step.to_s, :id => @order.ref
      else
        render @order.next_step.to_s
      end
    end

    def

    def cart
    end

    def validate
    end
    
    def addresses
      @order.init_addresses!
    end

    def validate_addresses
    end

    def payment_method
      @order.init_payment!
    end

    def payment
      cookies["glysellin.cart"] = { :value => '', :path => '/' }
    end

    def offline_payment
    end

    def gateway_response
      g = PaymentMethod.gateway(params[:goid] ? {:order_id => params[:goid]} : {:raw_post => request.raw_post, :gateway => params[:gateway]})

      if g.process_payment! request.raw_post
        OrderCustomerMailer.send_order_paid_email(g.order).deliver
        OrderAdminMailer.send_order_paid_email(g.order).deliver
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

    protected

    def init_order!
      @order = Order.find_by_ref(params[:id]) if params[:id]
    end
  end
end
