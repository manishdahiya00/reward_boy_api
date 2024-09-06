class User < ApplicationRecord
  has_many :app_opens
  has_many :redeem_requests
  has_many :transaction_histories
end
