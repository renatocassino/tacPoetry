# coding: utf-8
class Adverbio
  include Mongoid::Document
  store_in collection: "adverbios"

  field :word, type: String # Encontrada pelo dicionário
  field :stemmed, type: String
  field :type, type: String

  def self.get_word condition
    number = rand(0..self.all.count-1)
    word = self.limit(-1).skip(number).first
    word.word
  end
end
