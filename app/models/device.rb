class Device < ApplicationRecord
  belongs_to :gateway
  has_many :sensors
  has_many :device_status
end
