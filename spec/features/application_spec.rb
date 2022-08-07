require 'rails_helper'

Capybara.default_driver = :selenium_chrome_headless
WebMock.allow_net_connect!

RSpec.describe 'Application Homepage' do
  before { visit '/' }
  let(:search_word) { 'apple' }

  def perform_search_action
    fill_in 'searchField', with: search_word
    click_button 'Search'
  end

  context 'when the page loads' do
    it 'displays the application name, search form, and welcome message' do
      expect(page).to have_content('Doogle App')
      expect(find('#searchForm')).to be
      expect(page).to have_content('Please enter a word above to search for its definition')
    end
  end

  describe 'searching for a word' do
    let(:word_name) { find('#wordName')['innerHTML'] }

    context 'when searching for no word' do
      it 'displays a warning message' do
        click_button 'Search'
        expect(page).to have_content('The search form cannot be blank. Please try again.')
      end
    end

    context 'when searching for a standard word' do
      let!(:test_word) { create :word, :with_entries, name: search_word }
      it 'displays the word name, word function, and definition' do
        perform_search_action
        expect(word_name).to eq(test_word.name)
        expect(page).to have_content('test function')
        expect(page).to have_content('test')
      end
    end

    context 'when searching for a variant word' do
      let!(:test_variant) { create :variant, name: search_word}
      it 'displays a message indicating the word is a variant and the name of the base word' do
        perform_search_action
        expect(page).to have_content("Note: #{test_variant.name} is a variant of #{test_variant.word.name}")
        expect(word_name).to eq(test_variant.word.name)
      end
    end

    context 'when the dictionary API does not return word data' do
      before {
        stub_request(:get, "https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{search_word}?key=cab72891-f003-43ef-a983-253666d45082")
          .to_return(status: response_status, body: response_body, headers: { 'Content-Type' => 'application/json' })
      }
      context 'when the word is missing from the dictionary API' do
        let(:response_status) { 200 }
        let(:response_body) { '[]' }
        it 'should display a missing word message' do
          perform_search_action
          expect(page).to have_content("The word '#{search_word}' could not be found.")
        end
      end
      context 'when the dictionary API call fails' do
        let(:response_status) { 500 }
        let(:response_body) { '[]' }
        it 'should display a dictionary service failure message' do
          perform_search_action
          expect(page).to have_content("The dictionary service failed. Please try again.")
        end
      end
    end
  end
end
