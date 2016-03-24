=begin
  Nomenclatura Frank baseado na nomenclatura húngara.

  <time><variation>[:<singularOrPlural>][:<person>]

  Onde:
    1. time:
      1.1 => prt: pretérito
      1.2 => pre: presente
      1.3 => fut: futuro

    2. variation (optional):
      2.1 => pft: perfeito
      2.2 => imp: imperfeito
      2.3 => mqp: Mais que perfeito

    3. singularOrPlural:
      3.1 => sin: singular
      3.2 => plu: plural

    4. person
      4.1 => primeira: primeira pessoa
      4.2 => segunda: segunda pessoa
      4.3 => terceira: terceira pessoa

  Ex: Pretérito Pefeito Singular Primeira Pessoa => ptPftSin[:primeira]
      Presente Plural Segunda Pessoa             => prPlu[:segunda]
      Futuro do Pretérito Terceira Pessoa        => futPre[:terceira]

=end
class VerboIrregular
  include Mongoid::Document

  store_in collection: "verbos"

  field :word, type: String # Encontrada pelo dicionário
  field :stemmed, type: String
  field :prtPft, type: Hash
  field :prtImp, type: Hash
  field :prtMqp, type: Hash
  field :pre, type: Hash
  field :futPrt, type: Hash
  field :futPre, type: Hash

  def default
    {
        :sin => {
            primeira: nil,
            segunda: nil,
            terceira: nil
        },
        :plu => {
            primeira: nil,
            segunda: nil,
            terceira: nil
        }
    }
  end

  def initialize
    self.fields[:prtPft] = self.default
    self.fields[:prtImp] = self.default
    self.fields[:prtMqp] = self.default
    self.fields[:pre] = self.default
    self.fields[:futPrt] = self.default
    self.fields[:futPre] = self.default
    nil
  end
end