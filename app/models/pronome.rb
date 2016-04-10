# coding: iso-8859-1
class Pronome
  def self.data
    {
      sin: {
        primeira: "eu",
        segunda: "tu",
        terceira: {
          mas: ["ele", "voc�"],
          fem: ["ela", "voc�"]
        }
      },
      plu: {
        primeira: "n�s",
        segunda: "v�s",
        terceira: {
          mas: ["eles", "voc�s"],
          fem: ["elas", "voc�s"]
        }
      }
    }.freeze
  end

  def self.get_word condition
    conditions = condition.attributes

    if conditions[:numero].nil?
      numero = [:sin, :plu][SecureRandom.random_number(2)]
    else
      numero = conditions[:numero]
    end

    if conditions[:pessoa].nil?
      pessoa = [:primeira, :segunda, :terceira][SecureRandom.random_number(3)]
    else
      pessoa = conditions[:pessoa]
    end

    if conditions[:genero].nil?
      genero = [:mas, :fem][SecureRandom.random_number(2)]
    else
      genero = conditions[:genero]
    end

    pronome = self.data[numero][pessoa]
    return pronome if pronome.class.name == "String"
    pronome[genero].sample
  end
end
