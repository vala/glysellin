class CreateBrands < ActiveRecord::Migration
  def change
    create_table :glysellin_brands do |t|
      t.string :name

      t.timestamps
    end
  end
end
