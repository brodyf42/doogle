require 'api_result'

class WordsController < ApplicationController
  attr_reader :word, :variant, :search_word, :message

  def query
    @search_word = params[:name]
    query_local_database
    query_dictionary_api if word.blank?
    @message = "Note: #{variant.name} is a variant of #{word.name}" if variant.present?
    render json: { data: word.to_hash, message: message }
  rescue WordNotFoundError
    render json: { message: "The word '#{search_word}' could not be found." }
  rescue ApiQueryFailureError
    render json: { message: 'The dictionary service failed. Please try again.' }
  rescue
    render json: { message: 'An error occurred. Please try again.' }
  end

private
  def query_local_database
    @variant = Variant.case_insensitive_find('name', search_word)
    @word = variant.word if variant.present?
    @word ||= Word.case_insensitive_find('name', search_word)
  end

  def query_dictionary_api
    api_result = APIResult.new(search_word)
    if api_result.is_variant?
      @variant = Variant.create_for(api_result)
      @word = variant.word
    end
    @word ||= Word.create_for(api_result)
  end
end
