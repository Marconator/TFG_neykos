class Engine < ApplicationRecord
  belongs_to :gateway
  has_many :engine_status
end
