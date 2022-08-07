require 'rails_helper'

RSpec.describe Word do
  subject(:word) { create :word }

  describe 'validations' do
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_uniqueness_of(:name)}
  end

  describe '#to_hash' do
    subject(:word) { create(:word, :with_entries) }
    let(:expected_hash) { {
      name: word.name,
      entries: [
        {function: 'test function', definitions: %w[test test test]},
        {function: 'test function', definitions: %w[test test test]},
        {function: 'test function', definitions: %w[test test test]}
      ]
    } }

    it 'should return a Hash with only relevant data' do
      expect(word.to_hash).to eq(expected_hash)
    end
  end

  describe '.case_insensitive_find' do
    context 'when searched with the same case' do
      let(:search_result) { Word.case_insensitive_find('name', word.name) }
      it 'should find the word' do
        expect(word).to eq(search_result)
      end
    end
    context 'when searched with a different case' do
      let(:search_result) { Word.case_insensitive_find('name', word.name.swapcase) }
      it 'should find the word' do
        expect(word).to eq(search_result)
      end
    end
  end

  describe '.create_for' do
    let(:new_name) { 'rex' }
    let(:api_data) { instance_double('APIResult',{base_word: new_name, entries: []}) }
    subject(:word) { Word.create_for(api_data) }
    it 'should return a Word object' do
      expect(word).to be_a(Word)
    end
    describe 'returned Word object' do
      it 'should have the correct name' do
        expect(word.name).to eq(new_name)
      end
    end
  end
end
