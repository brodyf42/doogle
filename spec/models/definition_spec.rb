require 'rails_helper'

RSpec.describe Definition do
  subject { create :definition }

  describe 'validations' do
    it {is_expected.to belong_to :entry}
    it {is_expected.to validate_presence_of :entry_id}
    it {is_expected.to validate_presence_of :text}
  end

end
