module Glysellin
  module PropertyFinder
    def method_missing method, *args
      if (prop = find { |prop| prop.type.name == method.to_s })
        prop.value
      elsif Glysellin::ProductPropertyType.select('1').find_by_name(method)
        nil
      else
        super(method, *args)
      end
    end
  end
end