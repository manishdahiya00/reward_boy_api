class CreateRedeemRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :redeem_requests do |t|
      t.string :upi_id
      t.string :amount
      t.string :coins
      t.string :user_id
      t.string :status, default: "PENDING"

      t.timestamps
    end
  end
end
