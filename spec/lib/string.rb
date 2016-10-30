# coding: utf-8
require "rails_helper"

RSpec.describe '#String' do
  describe '.to_slug' do
    it 'should be remove open accents for vowels' do
      expect('análogo'.to_slug).to eq('analogo')
      expect('remédio'.to_slug).to eq('remedio')
      expect('paroxítona'.to_slug).to eq('paroxitona')
      expect('tórax'.to_slug).to eq('torax')
      expect('excrúpulo'.to_slug).to eq('excrupulo')
    end

    it 'should be remove close accents for vowels' do
      expect('câmara'.to_slug).to eq('camara')
      expect('você'.to_slug).to eq('voce')
      expect('estômago'.to_slug).to eq('estomago')
    end

    it 'shoud be in letter case' do
      expect('Brasil'.to_slug).to eq('brasil')
    end

    it 'should be transform ç in c' do
      expect('açucar'.to_slug).to eq('acucar')
    end

    it 'should be remove spaces' do
      expect('o brasil'.to_slug).to eq('o-brasil')
    end

    it 'should be remove multiple spaces' do
      expect('o  brasil'.to_slug).to eq('o-brasil')
    end

    it 'should be remove space in first char' do
      expect(' brasil'.to_slug).to eq('brasil')
    end

    it 'should be remove space in last char' do
      expect('brasil '.to_slug).to eq('brasil')
    end

    it 'should be remove tilde in vowels' do
      expect('não'.to_slug).to eq('nao')
      expect('anões'.to_slug).to eq('anoes')
    end
  end
end

