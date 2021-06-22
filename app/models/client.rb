class Client < ApplicationRecord
  has_many :emails
  has_many :gateways
  has_many :alerts
end
