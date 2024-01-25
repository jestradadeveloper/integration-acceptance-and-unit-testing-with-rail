class Achievement < ApplicationRecord
  validates :title, presence: true
end
