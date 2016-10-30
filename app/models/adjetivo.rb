# coding: utf-8
# Adjetivo
class Adjetivo
  include Mongoid::Document
  store_in collection: 'adjetivos'

  field :word, type: String # Encontrada pelo dicionario
  field :stemmed, type: String
  field :type, type: String

  def self.get_word(_)
    number = rand(0..all.count - 1)
    word = limit(-1).skip(number).first
    word.word
  end
end
