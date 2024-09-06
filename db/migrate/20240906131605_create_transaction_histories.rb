class CreateTransactionHistories < ActiveRecord::Migration[7.2]
  def change
    enable_extension("pgcrypto")
    create_table :transaction_histories, id: :uuid do |t|
      t.string :title
      t.string :subtitle
      t.string :amount
      t.string :user_id

      t.timestamps
    end
  end
end
