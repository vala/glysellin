module Glysellin
  module PropertyFinder
    def method_missing method, *args, &block
      if (prop = find { |prop| prop.type.name == method.to_s })
        prop.value
      elsif Glysellin::ProductPropertyType.select('1').find_by_name(method)
        false
      else
        super(method, *args, &block)
      end
    end
  end
end