require 'rails_helper'

RSpec.describe Entry do
  subject(:entry) { create :entry }

  describe 'validations' do
    it {is_expected.to belong_to :word}
    it {is_expected.to validate_presence_of :word_id}
    it {is_expected.to validate_presence_of :function}
  end

  describe '#to_hash' do
    subject(:entry) { create(:entry, :with_definitions) }
    let(:expected_hash) { {
      function: entry.function,
      definitions: %w[test test test]
    } }

    it 'should return a Hash with only relevant data' do
      expect(entry.to_hash).to eq(expected_hash)
    end
  end

  describe '.create_for' do
    let(:word) { create :word }
    let(:api_entry) { JSON.parse(file_fixture("api_entry_data.json.erb").read) }
    subject(:entry) { Entry.create_for(word,api_entry) }
    it 'should return an Entry object' do
      expect(entry).to be_an(Entry)
    end
    describe 'returned Entry object' do
      it 'should have a function' do
        expect(entry.function).to eq('noun')
      end
      it 'should have definitions' do
        expect(entry.definitions).to_not be_empty
      end
      it 'should be associated to the correct word' do
        expect(entry.word).to eq(word)
      end
    end
  end
end
