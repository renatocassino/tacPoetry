require 'rails_helper'

RSpec.describe Artigo do
  describe '#artigo' do
    it 'defined singular masculine' do
      expect(Artigo.get_artigo(:defined, :mas, :sin)).to eq 'o'
    end

    it 'undefined singular masculine' do
      expect(Artigo.get_artigo(:undefined, :mas, :sin)).to eq('um')
    end

    it 'defined plural masculine' do
      expect(Artigo.get_artigo(:defined, :mas, :plu)).to eq('os')
    end

    it 'undefined plural masculine' do
      expect(Artigo.get_artigo(:undefined, :mas, :plu)).to eq('uns')
    end

    it 'defined singular feminine' do
      expect(Artigo.get_artigo(:defined, :fem, :sin)).to eq 'a'
    end

    it 'undefined singular feminina' do
      expect(Artigo.get_artigo(:undefined, :fem, :sin)).to eq('uma')
    end

    it 'defined plural feminine' do
      expect(Artigo.get_artigo(:defined, :fem, :plu)).to eq('as')
    end

    it 'undefined plural feminine' do
      expect(Artigo.get_artigo(:undefined, :fem, :plu)).to eq('umas')
    end
  end
end
