class Artigo
  def self.data
    {
        defined: {
            word: 'o',
            mas: {
                sin: 'o',
                plu: 'os'
            },
            fem: {
                sin: 'a',
                plu: 'as'
            }
        },
        undefined: {
            word: 'um',
            mas: {
                sin: 'um',
                plu: 'uns'
            },
            fem: {
                sin: 'uma',
                plu: 'umas'
            }
        },
    }.freeze
  end

  def self.get_word condition
    conditions = condition.attributes
    if conditions[:is_defined].nil?
      is_defined = [:defined, :undefined][SecureRandom.random_number(2)]
    end

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

    self.data[is_defined][genero][numero]
  end

  def self.get_artigo(defined=:defined, genre=:mas, number=:sin)
    data[defined][genre][number]
  end
end
