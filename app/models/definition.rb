class Definition < ApplicationRecord
  belongs_to :entry
  validates :entry_id, presence: true
  validates :text, presence: true
end
