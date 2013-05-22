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
      # Get gateway object
      gateway = if params[:id]
        PaymentMethod.gateway_from_order_ref(params[:id])
      else
        PaymentMethod.gateway_from_raw_post(request.raw_post, params[:gateway])
      end
      # Process payment
      if gateway.process_payment! request.raw_post
        OrderCustomerMailer.send_order_paid_email(gateway.order).deliver
        OrderAdminMailer.send_order_paid_email(gateway.order).deliver
      end
      # Log errors if existing
      gateway.errors.each do |msg|
        logger.error "[ Glysellin ] Gateway Error : #{ msg }"
      end if gateway.errors.length > 1

      render gateway.response
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
