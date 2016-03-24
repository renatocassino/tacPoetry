class Word
  include Mongoid::Document

  store_in collection: "words"

  field :word, type: String
  field :stemmed, type: String
  field :words, type: Array
  field :type, type: String
  field :info, type: String

  def self.type
    {
        :SUBSTANTIVO => 'substantivo',
        :ADJETIVO => 'adjetivo',
        :ADVERBIO => 'adverbio',
        :ARTIGO => 'artigo',
        :PREPOSICAO => 'preposicao',
        :VERBO_REGULAR => 'verbo_regular',
        :VERBO_IRREGULAR => 'verbo_irregular',
        :NUMERAL => 'numeral',
        :APOSITIVO => 'apositivo',
        :UNDEFINED => 'undefined'
    }
  end
end