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
end