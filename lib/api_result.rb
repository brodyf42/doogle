require 'uri'
require 'net/http'

class WordNotFoundError < StandardError; end
class ApiQueryFailureError < StandardError; end

class APIResult
  attr_reader :query_word
  def initialize(word)
    @query_word = word
    get_api_data(query_word)
    raise WordNotFoundError.new if missing_from_api?
    prune_entries
  end

  def is_variant?
    query_word.downcase != base_word.downcase
  end

  def entries
    data
  end

  def base_word
    return @base_word if @base_word
    pattern = /^(?<word>[a-zA-Z\-' ]+)(:[a-z\d]+)?$/
    word_id_string = entries[0]['meta']['id']
    regex_result = pattern.match(word_id_string)
    @base_word = regex_result[:word] if regex_result.present?
  end

  def self.get_function_for_entry(api_entry)
    api_entry['fl'] if api_entry.is_a? Hash
  end

  def self.get_definitions_for_entry(api_entry)
    api_entry['shortdef'] if api_entry.is_a? Hash
  end

private
  attr_reader :data
  def get_api_data(word)
    api_key = Rails.application.credentials.dig(:dictionary_api_key)
    api_url = "https://www.dictionaryapi.com/api/v3/references/collegiate/json/#{URI.encode(word)}?key=#{api_key}"
    response = Net::HTTP.get_response(URI(api_url))
    raise ApiQueryFailureError.new unless (response.is_a? Net::HTTPOK) && response.content_type == 'application/json'
    @data = JSON.parse(response.body)
  end

  def prune_entries
    pattern = /^#{base_word}(:[a-z\d]+)?$/
    @data.filter! { |entry| pattern.match?(entry['meta']['id']) }
  end

  def missing_from_api?
    #if the first element of the result is a string, then only a list of suggested words was returned
    data.empty? || data[0].is_a?(String) || base_word.blank?
  end

end
