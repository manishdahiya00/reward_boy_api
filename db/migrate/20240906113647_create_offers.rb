class CreateOffers < ActiveRecord::Migration[7.2]
  def change
    create_table :offers do |t|
      t.string :title
      t.string :subtitle
      t.float :amount
      t.string :action_url
      t.text :small_img_url
      t.text :large_img_url
      t.text :description
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
