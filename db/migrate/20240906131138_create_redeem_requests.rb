class CreateRedeemRequests < ActiveRecord::Migration[7.2]
  def change
    enable_extension("pgcrypto")
    create_table :redeem_requests, id: :uuid do |t|
      t.string :upi_id
      t.string :amount
      t.string :coins
      t.string :user_id
      t.string :status, default: "PENDING"

      t.timestamps
    end
  end
end
