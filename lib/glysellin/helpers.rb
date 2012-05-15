require 'cgi'

module Glysellin
  # Extend String class only inside Glysellin namespace scope
  String.class_eval do
    # Converts a string to an URL friendly slug that can be used as
    #   product identifier
    #
    # @return [String] the slugged string
    def to_slug
      self.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    end
  end
  
  # Module that adds instance methods used through multiple models
  module ModelInstanceHelperMethods
    # Used for Rails to handle the parameterization of an object so
    #   it gets back a string instead of the normal id
    #
    # @return [String] The object's slug attribute
    def to_param
      slug
    end
  end
end
