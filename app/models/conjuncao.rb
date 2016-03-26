class Conjuncao
  include Mongoid::Document
  store_in collection: "conjuncao"

  field :word, type: String # Encontrada pelo dicionário
  field :stemmed, type: String
  field :type, type: String

  def self.get_word conditions
    number = rand(0..self.all.count-1)
    word = self.limit(-1).skip(number).first
    word.word
  end
end