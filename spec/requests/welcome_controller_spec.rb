require 'rails_helper'

RSpec.describe WelcomeController do
  describe '#index' do
    before { get '/' }
    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end
end
