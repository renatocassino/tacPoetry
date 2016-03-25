class Substantivo
  include Mongoid::Document

  store_in collection: "substantivos"

  field :word, type: String
  field :word_plural, type: String
  field :stemmed, type: String
  field :feminine_singular, type: String
  field :feminine_plural, type: String
  field :type, type: String
  field :syllables, type: String

  def self.get_word conditions
    number = rand(0..self.all.count-1)
    word = self.limit(-1).skip(number).first
    word.word
  end
end