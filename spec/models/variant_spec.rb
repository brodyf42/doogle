require 'rails_helper'

RSpec.describe Variant do
  subject(:variant) { create :variant }

  describe 'validations' do
    it {is_expected.to belong_to :word}
    it {is_expected.to validate_presence_of :word_id}
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_uniqueness_of(:name)}
  end

  describe '.case_insensitive_find' do
    context 'when searched with the same case' do
      let(:search_result) { Variant.case_insensitive_find('name', variant.name) }
      it 'should find the variant' do
        expect(variant).to eq(search_result)
      end
    end
    context 'when searched with a different case' do
      let(:search_result) { Variant.case_insensitive_find('name', variant.name.swapcase) }
      it 'should find the variant' do
        expect(variant).to eq(search_result)
      end
    end
  end

  describe '.create_for' do
    let(:parent_word) { create(:word, name: 'old') }
    let(:variant_name) { 'oldest' }
    let(:api_data) { instance_double('APIResult',{base_word: parent_word.name, query_word: variant_name}) }
    subject(:variant) { Variant.create_for(api_data) }
    it 'should return a Variant object' do
      expect(variant).to be_a(Variant)
    end
    describe 'returned Variant object' do
      it 'should have the correct variant name' do
        expect(variant.name).to eq(variant_name)
      end
    end
    context 'when the parent word exists in the database' do
      it 'should not call the Word model .create_for method' do
        expect(Word).to_not receive(:create_for)
      end
      it 'should associate the new Variant to the existing Word' do
        expect(variant.word).to eq(parent_word)
      end
    end
    context 'when the parent word is not yet in the database' do
      let(:api_data) { double('api_data',{base_word: 'missing', query_word: variant_name}) }
      it 'should call the Word model .create_for method' do
        expect(Word).to receive(:create_for) { create :word }
        variant
      end
    end
  end
end
