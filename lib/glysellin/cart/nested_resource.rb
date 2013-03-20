module Glysellin
  module Cart
    module NestedResource
      extend ActiveSupport::Concern

      module ClassMethods
        def nested_resource name, options = {}
          key = name.to_s
          model_name = options[:class_name] || key.camelize

          class_eval <<-EVAL, __FILE__, __LINE__ + 1
            def #{ key }_attributes=(attributes)
              attributes.each do |attr, value|
                self.#{ key }.public_send("\#{ attr }=", value)
              end
            end

            def #{ key }
              @#{ key } ||= #{ model_name }.new
            end

            def #{ key }=(attributes)
              if attributes.is_a? Hash
                self.#{ key }_attributes = attributes
              elsif attributes.is_a? #{ model_name }
                @#{ key } = #{ model_name }.new(attributes)
              else
                @#{ key } = attributes
              end
            end
          EVAL
        end

      end
    end
  end
end