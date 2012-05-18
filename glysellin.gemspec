$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "glysellin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "glysellin"
  s.version     = Glysellin::VERSION
  s.authors     = ["Valentin Ballestrino"]
  s.email       = ["vala@glyph.fr"]
  s.homepage    = "http://www.glyph.fr"
  s.summary     = "Lightweight e-commerce"
  s.description = "When your customer doesn't want e-commerce but actually you need products, orders and a payment gateway"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "paperclip"
  s.add_dependency "money"
  s.add_dependency "activemerchant"

  s.add_development_dependency "mysql2"
end
