require 'rails_helper'

RSpec.describe Artigo do
  describe '#artigo' do
    it 'singular masculine defined' do
      expect(Artigo.get_artigo(:defined, :mas, :sin)).to eq 'o'
    end
  end
end
