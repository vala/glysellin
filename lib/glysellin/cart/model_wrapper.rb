module Glysellin
  module Cart
    module ModelWrapper
      extend ActiveSupport::Concern
      include ActiveModel::Model

      def initialize attrs = {}
        assign_fields(attrs) if attrs.length > 0
      end

      def assign_fields attributes
        if attributes.class.to_s == model.model_name
          self.wrapped_model = attributes
        elsif (id = attributes[:id].presence)
          @id = id
          self.wrapped_model = model.find(id)
        else
          attributes.each do |field, value|
            key = field.to_s
            if attribute_names.include?(key)
              self.public_send(:"#{ key }=", value)
            end
          end
        end
      end

      def method_missing method, *args, &block
        reader_method = method.to_s.gsub(/\=$/, "")

        # If method is an attribute of the wrapped object
        if attribute_names.include?(reader_method) || reader_method == "id"
          wrapped_model.send(method, *args, &block)
        else
          super(method, *args, &block)
        end
      end

      def valid?
        wrapped_model.valid?
      end

      def errors
        wrapped_model.errors
      end

      module ClassMethods
        def wraps object_name, options = {}
          key = object_name.to_s
          # Try infer model_name if not given
          model_name = options[:class_name] || key.camelize
          attrs = (options[:attributes] || []).map(&:to_s)

          class_eval <<-EVAL, __FILE__, __LINE__ + 1
            attr_writer :#{ key }

            # Fetch wanted attributes to be serialized
            def attribute_names
              #{ attrs.inspect }.presence ||
                model._accessible_attributes[:default].select do |attr|
                  attr.presence
                end
            end

            def #{ key }
              @#{ key } ||= model.new
            end

            def model
              #{ model_name }
            end

            def attributes
              attribute_names.reduce({}) do |attrs, attr|
                attrs[attr] = public_send("\#{ attr }")
                attrs
              end
            end

            # Key agnostic accessor
            def wrapped_model() #{ key } end
            def wrapped_model=(val) self.#{ key } = val end
          EVAL
        end
      end
    end
  end
end