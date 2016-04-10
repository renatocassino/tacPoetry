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
    conditions = condition.attributes
    where = {}

    if conditions[:genero].nil?
      genero = [:mas, :fem][SecureRandom.random_number(2)]
    else
      genero = conditions[:genero]
    end

    if conditions[:numero].nil?
      numero = [:sin, :plu][SecureRandom.random_number(2)]
    else
      numero = conditions[:numero]
    end

    where[genero == :mas ? :has_mas : :has_fem] = true

    substantivos = self.where(where)
    number = SecureRandom.random_number(substantivos.count)
    word = self.limit(-1).skip(number).first
    eval("word.#{genero}_#{numero}")
  end
end
