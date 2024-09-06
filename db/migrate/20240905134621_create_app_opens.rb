class CreateAppOpens < ActiveRecord::Migration[7.2]
  def change
    enable_extension("pgcrypto")
    create_table :app_opens, id: :uuid do |t|
      t.string :version_name
      t.string :version_code
      t.string :source_ip
      t.string :user_id, null: false

      t.timestamps
    end
  end
end
