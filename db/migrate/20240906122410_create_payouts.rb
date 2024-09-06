class CreatePayouts < ActiveRecord::Migration[7.2]
  def change
    enable_extension("pgcrypto")
    create_table :payouts, id: :uuid do |t|
      t.string :title
      t.string :image
      t.string :amounts
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
