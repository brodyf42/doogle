require 'api_result'

class Entry < ApplicationRecord
  belongs_to :word
  has_many :definitions, :dependent => :destroy
  validates :word_id, presence: true
  validates  :function, presence: true

  def to_hash
    {
      function: function,
      definitions: definitions.map(&:text)
    }
  end

  def self.create_for(word, api_entry)
    function = APIResult.get_function_for_entry(api_entry)
    Entry.create!(word_id: word.id, function: function).tap do |entry|
      create_definitions_for_entry(entry)
    end
  end

  private

  def self.create_definitions_for_entry(entry)
    APIResult.get_definitions_for_entry(api_entry).each do |definition|
      Definition.create!(entry_id: entry.id, text: definition)
    end
  end
end
