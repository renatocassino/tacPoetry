# coding: utf-8
# Eu tu ele, nos vos eles
class Pronome
  def self.data
    {
      sin: {
        primeira: 'eu',
        segunda: 'tu',
        terceira: {
          mas: %w(ele você),
          fem: %w(ela você)
        }
      },
      plu: {
        primeira: 'nós',
        segunda: 'vós',
        terceira: {
          mas: %w(eles vocês),
          fem: %w(elas vocês)
        }
      }
    }.freeze
  end

  def self.get_word(condition)
    conditions = condition.attributes

    numero = conditions[:numero].nil? ?
               [:sin, :plu][SecureRandom.random_number(2)] :
               conditions[:numero]

    pessoa =  conditions[:pessoa].nil? ?
                [:primeira, :segunda, :terceira][SecureRandom.random_number(3)] :
                conditions[:pessoa]

    genero = conditions[:genero].nil? ?
               [:mas, :fem][SecureRandom.random_number(2)] :
               conditions[:genero]

    pronome = data[numero][pessoa]
    return pronome if pronome.class.name == 'String'
    pronome[genero].sample
  end
end

