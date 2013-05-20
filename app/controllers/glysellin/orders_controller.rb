module Glysellin
  class OrdersController < MainController
    protect_from_forgery :except => :gateway_response

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
  end
end
