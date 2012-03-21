module Glysellin
  module Gateway
    class Mercanet < Glysellin::Gateway::Base
      register 'mercanet', self
      
      mattr_accessor :bin_path
      @@bin_path = ''
      
      mattr_accessor :merchant_id
      @@merchant_id = ''
      
      mattr_accessor :pathfile_path
      @@pathfile_path = ''
      
      mattr_accessor :binaries_path
      @@binaries_path = ''
      
      mattr_accessor :binaries_path
      @@merchant_country = 'fr'
      
      mattr_accessor :capture_mode
      @@capture_mode = 'AUTHOR_CAPTURE'
      
      mattr_accessor :capture_days
      @@capture_days = nil
      
      mattr_accessor :debug
      @@debug = false
      
      attr_accessor :errors, :order
      
      def initialize order
        @order = order
        @errors = []
      end
      
      # Switch between test and prod modes for ActiveMerchant Paypal
      class << self
        # Extract order id from response data since it cannot be dynamically given via get URL
        def parse_order_id data
          parse_mercanet_resp(data)[32]
        end
        
        def parse_mercanet_resp data
          # Prepare arguments
          exec_chain = shell_escape("message=#{data}") << " " << "pathfile=#{@@pathfile_path}"
          bin_path = "#{@@bin_path}/response"
          # Call response program to get exclamation point separated payment response details
          `#{bin_path} #{exec_chain}`.split('!')
        end
      end
      
      def render_request_button
        exec_chain = {
          :merchant_id => @@merchant_id,
          :merchant_country => @@merchant_country,
          :capture_mode => @@capture_mode,
          :pathfile => @@pathfile_path,
          :data => @order.id,
          :amount => (@order.total_price * 100).to_i,
          :transaction_id => @order.payment.get_new_transaction_id
        }.to_a.map {|item| item[0].to_s + '=' + item[1].to_s}.join(' ')

        bin_path = "#{@@bin_path}/request"
        begin
          results = `#{bin_path} #{exec_chain}`.split('!')
        # If OS didn't want to exec program
        rescue Errno::ENOEXEC => msg
          results = []
        end
        
        # {
        #   :code => results[1].to_i,
        #   :err => results[2],
        #   :html_form => results[3],
        #   :executed_command => "#{bin_path} #{exec_chain}"
        # }
        
        { :text => (results.length == 0 ? "<div style=\"color:red\">#{bin_path} #{exec_chain}</div>" : results[1].to_i >= 0 ? results[3] : results[2]).html_safe }
      end

      # Launch payment processing
      def process_payment! post_data
        results = self.class.parse_mercanet_resp(post_data)
        # Réponse acceptée
        valid_response = results[1].to_i == 0
        # Renvoi de true si la réponse est positive ou de false si négative
        valid = valid_response && results[11] == 0

        result = valid ? @order.pay! : false

        @order.save
        result
      end

      # The response returned within "render" method in the OrdersController#gateway_response method
      def response
        {:nothing => true}
      end

      protected

        def shell_escape(str)
          String(str).gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').gsub(/\n/, "'\n'").sub(/^$/, "''")
        end
    end
  end
end