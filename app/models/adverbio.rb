# coding: utf-8
# Adverbio
class Adverbio
  include Mongoid::Document
  store_in collection: 'adverbios'

  field :word, type: String # Encontrada pelo dicionario
  field :stemmed, type: String
  field :type, type: String

  def self.get_word(_)
    number = rand(0..all.count - 1)
    word = limit(-1).skip(number).first
    word.word
  end
end
