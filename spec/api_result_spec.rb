require 'rails_helper'
require 'api_result'

describe APIResult do
  let(:search_word) { 'apple' }
  subject(:result) { described_class.new(search_word) }
  let(:api_key) { Rails.application.credentials.dig(:dictionary_api_key) }
  let(:api_response_body) { file_fixture("api_response_#{search_word}.json.erb").read }
  let(:api_response_content_type) { 'application/json' }
  let(:api_response_status) { 200 }
  before(:each) do
    stub_request(:get, "https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{search_word}?key=#{Rails.application.credentials.dig(:dictionary_api_key)}")
      .to_return(
        status: api_response_status,
        body: api_response_body,
        headers: { 'Content-Type' => api_response_content_type }
      )
  end

  describe 'initialization' do
    shared_examples_for 'raising an error' do
      it "raises an error" do
        expect{result}.to raise_error(raised_error)
      end
    end
    context 'when the word is missing from the API' do
      let(:raised_error) { WordNotFoundError }
      context 'when API provides list of close words' do
        let(:search_word) { 'aple' }
        it_behaves_like 'raising an error'
      end
      context 'when the API returns no data' do
        let(:api_response_body) { '[]' }
        it_behaves_like 'raising an error'
      end
    end
    context 'when the API returns non-JSON content' do
      let(:raised_error) { ApiQueryFailureError }
      let(:api_response_content_type) {'text/html'}
      it_behaves_like 'raising an error'
    end
    context 'when the API returns a non-successful status' do
      let(:raised_error) { ApiQueryFailureError }
      let(:api_response_status) { 500 }
      it_behaves_like 'raising an error'
    end
    context 'when initialization is successful' do
      describe '@query_word' do
        it 'should be set to the input argument' do
          expect(result.query_word).to eq(search_word)
        end
      end
    end
  end

  describe '#base_word' do
    subject(:base_word) {result.base_word}
    context 'when the API returns data for a standard word' do
      it 'returns the searched word' do
        expect(base_word).to eq('apple')
      end
    end
    context 'when the API returns data for a variant word' do
      let(:search_word){'oldest'}
      it 'returns the parent word' do
        expect(base_word).to eq('old')
      end
    end
  end

  describe '#is_variant?' do
    context 'when the API returns data for a standard word' do
      it 'returns false' do
        expect(result.is_variant?).to be false
      end
    end
    context 'when the API returns data for a variant word' do
      let(:search_word){'oldest'}
      it 'returns true' do
        expect(result.is_variant?).to be true
      end
    end
  end

  describe '#entries' do
    context 'when the API returns data with a single (non-indexed) base word entry' do
      let(:entries) {  [ JSON.parse(file_fixture("api_entry_data.json.erb").read) ] }
      it 'returns a filtered array with a single entry hash element' do
        expect(result.entries).to eq(entries)
      end
    end
    context 'when the API returns data with a multiple (indexed) base word entries' do
      let(:search_word) { 'old' }
      let(:entries) {  JSON.parse(file_fixture("api_entries_old.json.erb").read) }
      it 'returns a filtered array with multiple entry hash elements' do
        expect(result.entries).to eq(entries)
      end
    end
  end

  describe 'class level entry parsing methods' do
    let(:api_entry) { JSON.parse(file_fixture("api_entry_data.json.erb").read) }
    shared_examples_for 'returning nil' do
      it "returns nil" do
        expect(APIResult.get_function_for_entry(api_entry)).to be(nil)
      end
    end

    describe '.get_function_for_entry' do
      context 'when a valid entry hash with a function is provided' do
        let(:entry_function) { 'noun' }
        it 'returns the parsed word function as a string' do
          expect(APIResult.get_function_for_entry(api_entry)).to eq(entry_function)
        end
      end
      context 'when the function is not present in the entry hash' do
        let(:api_entry) { {} }
        it_behaves_like 'returning nil'
      end
      context 'when an invalid data type is provided' do
        let(:api_entry) { 5 }
        it_behaves_like 'returning nil'
      end
    end
    describe '.get_definitions_for_entry' do
      let(:entry_definitions) { JSON.parse(file_fixture("api_entry_data_definitions.json.erb").read) }
      context 'when a valid entry hash with definitions is provided' do
        it 'returns the parsed definitions as an array of strings' do
          expect(APIResult.get_definitions_for_entry(api_entry)).to eq(entry_definitions)
        end
      end
      context 'when the definitions are not present in the entry hash' do
        let(:api_entry) { {} }
        it_behaves_like 'returning nil'
      end
      context 'when an invalid data type is provided' do
        let(:api_entry) { nil }
        it_behaves_like 'returning nil'
      end
    end
  end

end
