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

    if conditions[:grau].nil?
      grau = [:sin, :plu][SecureRandom.random_number(2)]
    else
      grau = conditions[:grau]
    end

    self.data[is_defined][genero][grau]
  end

  def self.get_artigo(genre=:mas, number=:sin)
    data = self.data
    data[rand(0..data.count-1)][genre][number]
  end
end
