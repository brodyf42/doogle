require 'rails_helper'

RSpec.describe WordsController do
  let(:name_param) { 'apple' }
  let(:expected_response) { file_fixture("words_controller_response_#{name_param}.json.erb").read.strip }

  context 'when the word already exists in the local database' do
    let(:expected_response) { JSON.generate({data: {name: name_param, entries: []}, message: nil}) }
    before(:each) {
      Word.destroy_all
      create(:word, name: name_param)
    }

    it 'should not make a call to the API' do
      expect(APIResult).to_not receive(:new)
      get "/api/words/#{name_param}"
    end

    it 'should return word data' do
      get "/api/words/#{name_param}"
      expect(response.body).to eq(expected_response)
    end

    context 'when requesting a variant word' do
      let(:variant_name) {'variant'}
      let(:variant_message) { "Note: #{variant_name} is a variant of" }
      it 'should return a variant message' do
        create(:variant, name: variant_name)
        get "/api/words/#{variant_name}"
        expect(response.body).to include(variant_message)
      end
    end
  end

  context 'when the dictionary API needs to be called' do
    let(:api_response_body) { file_fixture("api_response_#{name_param}.json.erb").read }
    let(:api_response_content_type) { 'application/json' }
    before {
      stub_request(:get, "https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{name_param}?key=#{Rails.application.credentials.dig(:dictionary_api_key)}")
        .to_return(
          status: 200,
          body: api_response_body,
          headers: { 'Content-Type' => api_response_content_type })
    }

    it 'should make a call to the dictionary API' do
      expect(APIResult).to receive(:new).and_call_original
      get "/api/words/#{name_param}"
    end

    shared_examples_for 'returning the expected response' do
      it 'returns the appropriate JSON response' do
        get "/api/words/#{name_param}"
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when requesting a standard word' do
      it_behaves_like 'returning the expected response'
    end
    context 'when requesting a missing word' do
      let(:api_response_body) { '[]' }
      let(:expected_response) { "{\"message\":\"The word '#{name_param}' could not be found.\"}" }
      it_behaves_like 'returning the expected response'
    end
    context 'when the dictionary API call fails' do
      let(:api_response_content_type) { 'text/html' }
      let(:expected_response) { '{"message":"The dictionary service failed. Please try again."}' }
      it_behaves_like 'returning the expected response'
    end
  end

  context 'when an unexpected error is encountered' do
    before { allow(Variant).to receive(:case_insensitive_find).and_raise(StandardError) }
    let(:expected_response) { '{"message":"An error occurred. Please try again."}' }
    it 'returns the appropriate JSON response' do
      get "/api/words/#{name_param}"
      expect(response.body).to eq(expected_response)
    end
  end

end
