class Variant < ApplicationRecord
  belongs_to :word
  validates :word_id, presence: true
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.case_insensitive_find (attribute,value)
    Variant.where("LOWER(#{attribute}) = ?", value.downcase).first
  end

  def self.create_for(api_data)
    parent = Word.case_insensitive_find('name', api_data.base_word)
    parent ||= Word.create_for(api_data)
    Variant.create!(word_id: parent.id, name: api_data.query_word.downcase)
  end
end
