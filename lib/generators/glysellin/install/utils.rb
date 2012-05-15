module Glysellin
  module Generators
    module Utils
      module InstanceMethods
        def do_say str, color = :green
          say "[ Glysellin ] #{str}", color
        end
      end
    end
  end
end