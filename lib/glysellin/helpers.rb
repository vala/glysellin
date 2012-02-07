module Glysellin
  String.class_eval do
    def to_slug
      self.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end    
  end
end