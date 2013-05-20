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
              self.#{ key }.assign_fields(attributes)
            end

            def #{ key }
              @#{ key } ||= #{ model_name }.new
            end

            def #{ key }=(attributes)
              if attributes.is_a? Hash
                if (id = attributes.with_indifferent_access[:id].presence)
                  @#{ key } = #{ model_name }.new(id: id)
                else
                  self.#{ key }_attributes = attributes
                end
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