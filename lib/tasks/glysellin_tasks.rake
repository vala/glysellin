# encoding: utf-8
namespace :glysellin do
  task :seed => :environment do
    [['Chèque', 'check'],
    ['Paypal', 'paypal-integral'],
    ['BNP Paribas', 'mercanet'],
    ['Société Général', 'sogenactif']].each do |payment_method|
      attributes = Hash[[:name, :slug].zip(payment_method)]
      Glysellin::PaymentMethod.create(attributes)
      puts "Created payment method : #{ attributes[:name] }"
    end
  end
end
