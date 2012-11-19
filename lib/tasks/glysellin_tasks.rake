# encoding: utf-8
require 'fileutils'

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

  task :copy_views => :environment do
    folder = %w(app views glysellin)
    source_dir = File.expand_path(File.join('..', '..', '..', *folder), __FILE__)
    dest_dir = Rails.root.join(*folder)
    print "Copying glysellin views folder to #{ dest_dir } ... "
    FileUtils.cp_r source_dir, dest_dir
    puts "done !"
  end
end
