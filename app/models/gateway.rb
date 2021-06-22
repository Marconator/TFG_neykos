class Gateway < ApplicationRecord
  has_many :engines
  has_many :devices
  has_one :hardware
  belongs_to :client
end
