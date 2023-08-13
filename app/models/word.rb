class Word < ApplicationRecord
  has_many :entries, :dependent => :destroy
  has_many :variants, :dependent => :destroy
  validates :name, presence: true
  validates :name, uniqueness: true

  def self.case_insensitive_find (attribute,value)
    Word.where("LOWER(#{attribute}) = ?", value.downcase).first
  end

  def to_hash
    {
      name: name,
      entries: entries.map(&:to_hash)
    }
  end

  def self.create_for(api_data)
    new_word = nil
    transaction do
      new_word = Word.where(name: api_data.base_word).first_or_create!
      api_data.entries.each {|api_entry| Entry.create_for(new_word, api_entry) } if new_word.entries.empty?
    end
    new_word
  end
end
