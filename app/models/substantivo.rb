class Substantivo
  include Mongoid::Document

  store_in collection: "substantivos"

  field :has_mas, type: Boolean
  field :has_fem, type: Boolean
  field :stemmed, type: String
  field :fem_sin, type: String
  field :fem_plu, type: String
  field :mas_sin, type: String
  field :mas_plu, type: String
  field :type, type: String

  def self.get_word condition
    number = rand(0..self.all.count-1)
    word = self.limit(-1).skip(number).first
    word.word
  end
end
