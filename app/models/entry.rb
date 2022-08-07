require 'api_result'

class Entry < ApplicationRecord
  belongs_to :word
  has_many :definitions, :dependent => :destroy
  validates :word_id, presence: true
  validates  :function, presence: true

  def to_hash
    {
      function: function,
      definitions: definitions.map {|definition| definition.text }
    }
  end

  def self.create_for(word, api_entry)
    function = APIResult.get_function_for_entry(api_entry)
    definition_list = APIResult.get_definitions_for_entry(api_entry)
    new_entry = Entry.create!(word_id: word.id, function: function)
    definition_list.each {|definition| Definition.create!(entry_id: new_entry.id, text: definition) }
    new_entry
  end
end
