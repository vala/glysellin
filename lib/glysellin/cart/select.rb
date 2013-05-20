module Glysellin
  module Cart
    module Select
      extend ActiveSupport::Concern

      module ClassMethods
        def select name, options = {}
          key = name.to_s
          model_name = options[:class_name] || key.camelize

          class_eval <<-EVAL, __FILE__, __LINE__ + 1
            attr_accessor :#{ key }_id

            def #{ key }
              if @#{ key } && @#{ key }.id == #{ key }_id
                @#{ key }
              elsif #{ key }_id
                @#{ key } = #{ model_name }.find(#{ key }_id)
              end
            end

            def #{ key }=(object)
              self.#{ key }_id = object.id
              @#{ key } = object
            end
          EVAL
        end
      end
    end
  end
end