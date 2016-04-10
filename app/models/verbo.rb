# coding: utf-8
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

class Verbo
  include Mongoid::Document
  store_in collection: "verbos"

  field :word, type: String # Encontrada pelo dicionário
  field :stemmed, type: String
  field :type, type: String
  field :prtPft, type: Hash
  field :prtImp, type: Hash
  field :prtMqp, type: Hash
  field :pre, type: Hash
  field :futPrt, type: Hash
  field :futPre, type: Hash

  def types
    {
        :regular => 'regular',
        :irregular => 'irregular'
    }.freeze
  end

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

  def init params={}
    self.fields[:prtPft] = self.default
    self.fields[:prtImp] = self.default
    self.fields[:prtMqp] = self.default
    self.fields[:pre] = self.default
    self.fields[:futPrt] = self.default
    self.fields[:futPre] = self.default
    self.fields[:type] = self.types[:regular]
  end

  def self.test
    verbo = Verbo.new
    verbo.word = 'pular'
    verbo.stemmed = 'pul'
    verbo.type = 'regular'
    condition = Poetry::Condition.new
    condition.set_conditions "tempo:futPre&pessoa:terceira"
    verbo.get_conjugado condition
  end

  def get_conjugado condition
    byebug
    conditions = condition.attributes

    if conditions[:tempo].nil?
      keys = self.conjugado.keys
      tempo = keys[SecureRandom.random_number(keys.count)]
    else
      tempo = conditions[:tempo]
    end

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

    if self.type == self.types[:regular]
      self.conjugado[tempo][numero][pessoa]
    else
      command = "self.#{tempo}[#{numero}][#{pessoa}]"
      eval command
    end
  end

  def conjugado
    # Magia here
    word = self.stemmed
    {
      :prtPft => {
          :sin => {
              primeira: "#{word}ei",
              segunda: "#{word}aste",
              terceira: "#{word}ou"
          },
          :plu => {
              primeira: "#{word}amos",
              segunda: "#{word}astes",
              terceira: "#{word}aram"
          }
      },
      :prtImp => {
          :sin => {
              primeira: "#{word}ava",
              segunda: "#{word}avas",
              terceira: "#{word}ava"
          },
          :plu => {
              primeira: "#{word}ávamos",
              segunda: "#{word}áveis",
              terceira: "#{word}avam"
          }
      },
      :prtMqp => {
          :sin => {
              primeira: "#{word}ara",
              segunda: "#{word}aras",
              terceira: "#{word}ara"
          },
          :plu => {
              primeira: "#{word}áramos",
              segunda: "#{word}áreis",
              terceira: "#{word}aram"
          }
      },
      :pre => {
          :sin => {
              primeira: "#{word}o",
              segunda: "#{word}as",
              terceira: "#{word}a"
          },
          :plu => {
              primeira: "#{word}amos",
              segunda: "#{word}ais",
              terceira: "#{word}am"
          }
      },
      :futPrt => {
          :sin => {
              primeira: "#{word}aria",
              segunda: "#{word}arias",
              terceira: "#{word}aria"
          },
          :plu => {
              primeira: "#{word}aríamos",
              segunda: "#{word}aríeis",
              terceira: "#{word}ariam"
          }
      },
      :futPre => {
          :sin => {
              primeira: "#{word}arei",
              segunda: "#{word}arás",
              terceira: "#{word}ará"
          },
          :plu => {
              primeira: "#{word}aremos",
              segunda: "#{word}areis",
              terceira: "#{word}arão"
          }
      }
    }.freeze
  end
end
