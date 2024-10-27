class CreateTransactionHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :transaction_histories do |t|
      t.string :title
      t.string :subtitle
      t.string :amount
      t.string :user_id
      t.string :redeem_request_id

      t.timestamps
    end
  end
end
