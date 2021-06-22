class Alert < ApplicationRecord
  belongs_to :alert_type
  belongs_to :client
end
